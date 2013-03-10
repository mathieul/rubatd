require "nest"

class Rubatd::DataStore
  attr_reader :db

  def initialize(type, config)
    raise RuntimeError, "We only support redis" unless type == :redis
    @db = Redis.new(config)
  end

  def create(model)
    serializer = RedisModelSerializer.new(model, db)
    model.id = serializer.id
    serializer.save
    true
  end
end
