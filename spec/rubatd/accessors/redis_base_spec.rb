require "spec_helper"

include Rubatd

class RMModel
  attr_accessor :id, :errors
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

describe Accessors::RedisBase do
  let(:model) { RMModel.new }
  let(:accessor) { Accessors::RedisBase.new(model, Redis.new(redis_config)) }

  context "#save" do
    it "#save raises an error if teammate is not valid" do
      model.should_receive(:valid?).and_return(false)
      expect { accessor.save }.to raise_error(ModelInvalid)
    end

    it "sets the model id if not persisted" do
      accessor.save
      expect(model.id).to eq("1")
    end

    it "doesn't set the model id if already set" do
      model.id = "42"
      accessor.save
      expect(model.id).to eq("42")
    end

    it "adds the model id to the list of all model ids" do
      accessor.save
      expect(redis.smembers("RMModel:all")).to eq(["1"])
      accessor.save
      expect(redis.smembers("RMModel:all")).to eq(["1"])
    end

    it "stores the model attributes" do
      accessor.save
      expect(redis.hgetall("RMModel:1")).to eq(
        "name" => "James Bond", "number" => "007"
      )
    end

    it "sets the model as persisted" do
      model.should_receive(:persisted!)
      accessor.save
    end
  end
end
