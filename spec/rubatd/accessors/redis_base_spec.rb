require "spec_helper"

include Rubatd

class RMModel
  attr_accessor :id, :errors, :attributes
  def initialize(attributes = {})
    @attributes = attributes
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

  context "#save: save to redis" do
    let(:model) { RMModel.new("name" => "James Bond", "number" => "007") }

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
      2.times do
        accessor.save(model)
        expect(redis.smembers("RMModel:all")).to eq(["1"])
      end
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

  context "#[]: read model from redis by id" do
    it "finds the model id" do
      accessor.save(RMModel.new("name" => "James Bond", "number" => "007"))
      model = accessor["1"]
      expect(model.attributes).to eq("id" => "1", "name" => "James Bond", "number" => "007")
    end

    it "raises an error if no model exists for this id" do
      expect { accessor["does-not-exist"] }.to raise_error(ModelNotFound)
    end
  end
end
