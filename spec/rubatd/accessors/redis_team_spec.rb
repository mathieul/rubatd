require "spec_helper"

include Rubatd

describe Accessors::RedisTeam do
  context "#save" do
    let(:team) { build(:team) }
    let(:accessor) { Accessors::RedisTeam.new(team, Redis.new(redis_config)) }

    it "sets the team id if not persisted" do
      accessor.save
      expect(team.id).to eq("1")
    end

    it "doesn't set the model id if already set" do
      team.id = "42"
      accessor.save
      expect(team.id).to eq("42")
    end

    it "adds the model id to the list of all model ids" do
      accessor.save
      expect(redis.smembers("Team:all")).to eq(["1"])
      accessor.save
      expect(redis.smembers("Team:all")).to eq(["1"])
    end

    it "stores the model attributes" do
      accessor.save
      expect(redis.hgetall("Team:1")).to eq("name" => team.name)
    end
  end
end
