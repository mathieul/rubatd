require "spec_helper"

include Rubatd

describe RedisAccessors::Skill do
  let(:skill) { build(:skill, name: "Sales") }
  let(:accessor) do
    RedisAccessors::Skill.new(Redis.new(redis_config))
  end

  it "is a redis accessor" do
    expect(accessor).to be_an(RedisAccessors::Base)
  end

  it "#save raises an error if team is not persisted" do
    skill.team = build(:team)
    expect { accessor.save(skill) }.to raise_error(ModelInvalid)
  end

  it "#save persists the team id" do
    accessor.save(skill)
    expect(redis.hgetall("Skill:1")).to eq(
      "name"        => "Sales",
      "team_id"     => "1",
      "queue_id"    => "1",
      "teammate_id" => "1"
    )
  end
end
