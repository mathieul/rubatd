require "nest"

class Rubatd::Accessors::RedisBase
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

  def attributes(model)
    model.attributes
  end

  def save(model)
    raise ModelInvalid, model.errors unless model.valid?
    model.id ||= next_id
    push_id(model.id)
    store_attributes(model.id, attributes(model))
    index_references(model)
    model.persisted!
    model
  end

  def get(id)
    attributes = read_attributes(id)
    raise ModelNotFound, "id = #{id.inspect}" if attributes.empty?
    model_klass.new(attributes.merge("id" => id))
  end

  def referrers(referrer_type, id)
    rkey = Nest.new(referrer_type, db)
    index_key = rkey["indices"]["#{type_name}Id".underscore][id]
    accessor = Rubatd::Accessors.for(:redis, db, referrer_type)
    index_key.smembers.map { |id| accessor.get(id) }
  end

  private

  def type_name
    self.class.to_s.split("::").last.sub(/^Redis/, '')
  end

  def model_klass
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

  def index_references(model)
    names = self.class.reference_names || []
    names.each do |name|
      if (reference = model.send(name))
        key["indices"]["#{name}_id"][reference.id].sadd(model.id)
      end
    end
  end
end
