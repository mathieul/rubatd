require "nest"

class Rubatd::RedisAccessors::Base
  attr_reader :db

  class << self
    attr_reader :reference_names

    def reference(referee_type)
      @reference_names ||= []
      @reference_names << referee_type.underscore
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

  def save(model)
    assert_saveable!(model)
    model.id ||= next_id
    push_id(model.id)
    store_attributes(model.id, model_attributes(model))
    index_references(model)
    model.persisted!
    model
  end

  def get(id)
    attributes = read_attributes(id)
    raise ModelNotFound, "id = #{id.inspect}" if attributes.empty?
    each_reference do |name|
      ref_id = attributes.delete("#{name}_id")
      next unless ref_id
      accessor = Rubatd::RedisAccessors.for(db, name.camelize)
      attributes[name] = accessor.get(ref_id)
    end
    klass.new(attributes.merge("id" => id))
  end

  def referrers(referrer_type, id)
    rkey = Nest.new(referrer_type, db)
    index_key = rkey["indices"]["#{type_name}Id".underscore][id]
    accessor = Rubatd::RedisAccessors.for(db, referrer_type)
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

  def store_attributes(id, attributes)
    key[id].hmset(*attributes.to_a)
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

  def index_references(model)
    each_reference do |name|
      if (referee = model.send(name))
        key["indices"]["#{name}_id"][referee.id].sadd(model.id)
      end
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
