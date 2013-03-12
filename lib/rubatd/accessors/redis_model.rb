require "nest"

class Rubatd::Accessors::RedisBase
  attr_reader :model, :db

  def initialize(model, db)
    @model = model
    @db = db
  end

  def generate_model_id
    model.id = model_key["id"].incr
  end

  def save
    model_key["all"].sadd(model.id)
    model_key[model.id].hmset(*model.attributes.to_a)
  end

  def model_key
    @model_key ||= Nest.new(model.type_name, db)
  end
end
