require "spec_helper"

include Rubatd

describe RedisAccessors::Queue do
  let(:queue) { build(:queue, name: "Sales") }
  let(:accessor) do
    RedisAccessors::Queue.new(Redis.new(redis_config))
  end

  it "is a redis accessor" do
    expect(accessor).to be_an(RedisAccessors::Base)
  end

  it "#save raises an error if team is not persisted" do
    queue.team = build(:team)
    expect { accessor.save(queue) }.to raise_error(ModelInvalid)
  end

  it "#save persists the team id" do
    accessor.save(queue)
    expect(redis.hgetall("Queue:1")).to eq(
      "name" => "Sales", "team_id" => "1"
    )
  end
end
