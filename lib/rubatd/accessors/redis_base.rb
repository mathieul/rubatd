require "nest"

class Rubatd::Accessors::RedisBase
  attr_reader :db

  def initialize(db)
    @db = db
  end

  def attributes(model)
    model.attributes
  end

  def save(model)
    raise ModelInvalid, model.errors unless model.valid?
    model.id ||= key.next_id
    key.push_id(model.id)
    key.store_attributes(model.id, attributes(model))
    model.persisted!
    model
  end

  def [](id)
    attributes = key.read_attributes(id)
    model_klass.new(attributes.merge("id" => id))
  end

  def type_name
    self.class.to_s.split("::").last.sub(/^Redis/, '')
  end

  def model_klass
    Rubatd.const_get(type_name)
  end

  def key
    @key ||= Key.new(type_name, db)
  end

  class Key
    attr_reader :key
    def initialize(type_name, db)
      @key = Nest.new(type_name, db)
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
  end
end
