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
    key = Key.new(model.type_name, db)
    model.id ||= key.next_id
    key.push_id(model.id)
    key.store_attributes(model.id, attributes(model))
    model.persisted!
    model
  end

  private

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
  end
end
