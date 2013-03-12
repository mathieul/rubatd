require "nest"

class Rubatd::Accessors::RedisBase
  attr_reader :model, :db

  def initialize(model, db)
    @model = model
    @db = db
  end

  def save
    model.id = next_id unless model.persisted?
    push_id(model.id)
    store_attributes(model.id, model.attributes)
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

  def key
    @key ||= Nest.new(model.type_name, db)
  end
end
