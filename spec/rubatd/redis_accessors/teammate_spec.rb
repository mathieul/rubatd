require "spec_helper"

include Rubatd

describe RedisAccessors::Teammate do
  let(:teammate) { build(:teammate, name: "Georges") }
  let(:accessor) do
    RedisAccessors::Teammate.new(Redis.new(redis_config))
  end

  it "is a redis accessor" do
    expect(accessor).to be_an(RedisAccessors::Base)
  end

  it "#save raises an error if team is not persisted" do
    teammate.team = build(:team)
    expect { accessor.save(teammate) }.to raise_error(ModelInvalid)
  end

  it "#save persists the team id" do
    accessor.save(teammate)
    expect(redis.hgetall("Teammate:1")).to eq(
      "name" => "Georges", "team_id" => "1"
    )
  end
end
