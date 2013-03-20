require "spec_helper"

include Rubatd

describe RedisAccessors::Task do
  let(:task) { build(:task, title: "Buy milk") }
  let(:accessor) do
    RedisAccessors::Task.new(Redis.new(redis_config))
  end

  it "is a redis accessor" do
    expect(accessor).to be_an(RedisAccessors::Base)
  end

  it "#save raises an error if team is not persisted" do
    task.team = build(:team)
    expect { accessor.save(task) }.to raise_error(ModelInvalid)
  end

  it "#save persists the team id" do
    accessor.save(task)
    expect(redis.hgetall("Task:1")).to eq(
      "title" => "Buy milk", "team_id" => "1"
    )
  end
end
