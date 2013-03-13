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
    model.id ||= next_id
    push_id(model.id)
    store_attributes(model.id, attributes(model))
    model.persisted!
    model
  end

  def [](id)
    attributes = read_attributes(id)
    raise ModelNotFound, "id = #{id.inspect}" if attributes.empty?
    model_klass.new(attributes.merge("id" => id))
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
end
