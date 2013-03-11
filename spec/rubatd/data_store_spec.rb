require "spec_helper"

include Rubatd

class DSModel
  attr_accessor :id, :name, :number
  def initialize(attributes)
    attributes.each { |n, v| send(:"#{n}=", v) }
  end
  def attributes
    {"name" => name, "number" => number}
  end
end

class Rubatd::Stores::RedisDSModel < Rubatd::Stores::RedisModel
end

describe DataStore do
  let(:store) { DataStore.new(:redis, Redis, redis_config) }

  it "is initialized for a database" do
    expect(store.db).to be_a(Redis)
  end

  context "create a model to redis" do
    let(:model) { DSModel.new(name: "ze model", number: "42") }
    before(:each) { store.create(model) }

    it "retrieves a new id from redis" do
      expect(model.id).to eq(1)
    end

    it "stores the model id" do
      expect(redis.smembers("DSModel:all")).to eq(["1"])
    end

    it "stores the hash of attributes" do
      expect(redis.hgetall("DSModel:1")).to eq("name" => "ze model", "number" => "42")
    end
  end
end
