require "nest"

module Rubatd
  class RedisAccessors::Base
    attr_reader :db

    class << self
      attr_reader :reference_names, :embedded_keys

      def reference(referee_type)
        @reference_names ||= []
        @reference_names << referee_type.underscore
      end

      def embedded_key(name, &block)
        @embedded_keys ||= []
        @embedded_keys << [name, block]
      end
    end

    def initialize(db)
      @db = db
    end

    def each_reference
      names = self.class.reference_names || []
      return names.each unless block_given?
      names.each do |name|
        yield name
      end
    end

    def save(*models)
      attributes = []
      models.each do |model|
        assert_saveable!(model)
        model.id ||= next_id
        attributes << model_attributes(model)
      end
      db.multi do
        models.each.with_index do |model, i|
          push_id(model.id)
          store_attributes(model.id, attributes[i])
          cleanup_references(model)
          index_references(model)
          update_embedded_keys(model)
        end
      end
      models.each.with_index { |model, i| model.persisted!(attributes[i]) }
      true
    end

    def get(id)
      attributes = read_attributes(id)
      raise ModelNotFound, "id = #{id.inspect}" if attributes.empty?
      each_reference do |name|
        ref_id = attributes.delete("#{name}_id")
        next unless ref_id
        accessor = RedisAccessors.for(db, name.camelize)
        attributes[name] = accessor.get(ref_id)
      end
      model = klass.new(attributes.merge("id" => id))
      model.persisted!(attributes)
      model
    end

    def delete(model)
      db.multi do
        cleanup_references(model)
        remove_attributes(model.id)
        remove_id(model.id)
        remove_embedded_keys(model.id)
      end
      model.not_persisted!
    end

    def referrers(referrer_type, id)
      rkey = Nest.new(referrer_type, db)
      index_key = rkey["indices"]["#{type_name}Id".underscore][id]
      accessor = RedisAccessors.for(db, referrer_type)
      index_key.smembers.map { |id| accessor.get(id) }
    end

    private

    def type_name
      self.class.to_s.split("::").last.sub(/^Redis/, '')
    end

    def klass
      Rubatd.const_get(type_name)
    end

    def key
      @key ||= Nest.new(type_name, db)
    end

    def next_id
      key["id"].incr.to_s
    end

    def push_id(id)
      key["all"].sadd(id)
    end

    def remove_id(id)
      key["all"].srem(id)
    end

    def store_attributes(id, attributes)
      key[id].hmset(*attributes.to_a)
    end

    def remove_attributes(id)
      key[id].del
    end

    def read_attributes(id)
      key[id].hgetall
    end

    def model_attributes(model)
      model.attributes.dup.tap do |attributes|
        each_reference do |name|
          referee = attributes.delete(name)
          attributes["#{name}_id"] = referee.id if referee
        end
      end
    end

    def cleanup_references(model)
      return unless model.persisted?
      each_reference do |name|
        persisted_id = model.persisted_attributes["#{name}_id"]
        index_for(name, persisted_id).srem(model.id)
      end
    end

    def index_references(model)
      each_reference do |name|
        if (referee = model.send(name))
          index_for(name, referee.id).sadd(model.id)
        end
      end
    end

    def index_for(name, id)
      key["indices"]["#{name}_id"][id]
    end

    def update_embedded_keys(model)
      Array(self.class.embedded_keys).each do |name, block|
        block.call(model, key[model.id][name])
      end
    end

    def remove_embedded_keys(id)
      Array(self.class.embedded_keys).each do |name, block|
        key[id][name].del
      end
    end

    def assert_saveable!(model)
      raise ModelInvalid, model.errors unless model.valid?
      each_reference do |name|
        referee = model.send(name)
        raise ModelNotSaved, name if referee && !referee.persisted?
      end
    end
  end
end
