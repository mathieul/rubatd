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

describe Accessors::RedisBase do
  let(:model) { RMModel.new }
  let(:accessor) { Accessors::RedisBase.new(model, Redis.new(redis_config)) }

  context "#save" do
    before(:each) do
      model.id = "42"
      model.stub(:persisted?).and_return(true)
      accessor.save
    end

    it "sets the model id if not persisted" do
      model.should_receive(:persisted?).and_return(false)
      accessor.save
      expect(model.id).to eq("1")
    end

    it "doesn't set the model id if it is persisted already" do
      expect(model.id).to eq("42")
    end

    it "pushes the model id to the list of all model ids" do
      expect(redis.smembers("RMModel:all")).to eq(["42"])
    end

    it "stores the model attributes" do
      expect(redis.hgetall("RMModel:42")).to eq("name" => "James Bond", "number" => "007")
    end
  end
end
