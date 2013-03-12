require "spec_helper"

include Rubatd

describe Accessors::RedisTeammate do
  context "#save" do
    let(:teammate) { build(:teammate) }
    let(:accessor) { Accessors::RedisTeammate.new(teammate, Redis.new(redis_config)) }

    it "sets the teammate id if not persisted" do
      accessor.save
      expect(teammate.id).to eq("1")
    end

    it "doesn't set the model id if already set" do
      teammate.id = "42"
      accessor.save
      expect(teammate.id).to eq("42")
    end

    it "adds the model id to the list of all model ids" do
      accessor.save
      expect(redis.smembers("Teammate:all")).to eq(["1"])
      accessor.save
      expect(redis.smembers("Teammate:all")).to eq(["1"])
    end

    it "stores the model attributes" do
      accessor.save
      expect(redis.hgetall("Teammate:1")).to eq(
        "name" => teammate.name, "team_id" => teammate.team.id
      )
    end
  end
end
