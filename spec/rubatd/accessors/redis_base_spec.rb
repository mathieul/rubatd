require "spec_helper"

include Rubatd

class RMModel
  attr_accessor :id, :errors, :params
  def initialize(params = {})
    @params = params
  end
  def attributes
    {"name" => "James Bond", "number" => "007"}
  end
  def type_name
    "RMModel"
  end
  def valid?
    true
  end
  def persisted!
  end
end

Rubatd::Accessors::RedisRMModel = Class.new(Accessors::RedisBase)

describe Accessors::RedisBase do
  let(:accessor) { Accessors::RedisRMModel.new(Redis.new(redis_config)) }

  context "#save" do
    let(:model) { RMModel.new }

    it "#save raises an error if teammate is not valid" do
      model.should_receive(:valid?).and_return(false)
      expect { accessor.save(model) }.to raise_error(ModelInvalid)
    end

    it "sets the model id if not persisted" do
      accessor.save(model)
      expect(model.id).to eq("1")
    end

    it "doesn't set the model id if already set" do
      model.id = "42"
      accessor.save(model)
      expect(model.id).to eq("42")
    end

    it "adds the model id to the list of all model ids" do
      accessor.save(model)
      expect(redis.smembers("RMModel:all")).to eq(["1"])
      accessor.save(model)
      expect(redis.smembers("RMModel:all")).to eq(["1"])
    end

    it "stores the model attributes" do
      accessor.save(model)
      expect(redis.hgetall("RMModel:1")).to eq(
        "name" => "James Bond", "number" => "007"
      )
    end

    it "sets the model as persisted" do
      model.should_receive(:persisted!)
      accessor.save(model)
    end
  end

  context "#[]" do
    it "finds the model id" do
      accessor.save(RMModel.new)
      model = accessor["1"]
      expect(model.params).to eq("id" => "1", "name" => "James Bond", "number" => "007")
    end

    it "raises an error if no model exists for this id" do
      expect { accessor["does-not-exist"] }.to raise_error(ModelNotFound)
    end
  end
end
