require "nest"

class Rubatd::DataStore
  attr_reader :db

  def initialize(type, config)
    raise RuntimeError, "We only support redis" unless type == :redis
    @db = Redis.new(config)
  end

  def create(model)
    key = Nest.new(model.class.to_s, db)
    model.id = key["id"].incr
    key["all"].sadd(model.id)
    key[model.id].hmset(*model.attributes.to_a)
    true
  end
end
