require "spec_helper"

include Rubatd

class RMModel
  attr_accessor :id
  def attributes
    {"name" => "James Bond", "number" => "007"}
  end
  def type_name
    "RMModel"
  end
end

describe Accessors::RedisModel do
  let(:model) { RMModel.new }
  let(:redis_store) { Accessors::RedisModel.new(model, Redis.new(redis_config)) }

  it "#generate_model_id retrieves and sets a new id from redis" do
    redis_store.generate_model_id
    expect(model.id).to eq(1)
  end

  context "#save" do
    before(:each) { model.id = "42"; redis_store.save }

    it "stores the model id" do
      expect(redis.smembers("RMModel:all")).to eq(["42"])
    end

    it "stores the hash of attributes" do
      expect(redis.hgetall("RMModel:42")).to eq("name" => "James Bond", "number" => "007")
    end
  end
end
