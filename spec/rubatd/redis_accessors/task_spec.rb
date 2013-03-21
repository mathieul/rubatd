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

  context "#save" do
    it "raises an error if team is not persisted" do
      task.team = build(:team)
      expect { accessor.save(task) }.to raise_error(ModelInvalid)
    end

    it "persists the team id" do
      task.team = create(:team, id: "007")
      accessor.save(task)
      expect(redis.hgetall("Task:1")["team_id"]).to eq("007")
    end

    it "persists the queue id" do
      task.queue = create(:queue, id: "123")
      accessor.save(task)
      expect(redis.hgetall("Task:1")["queue_id"]).to eq("123")
    end

    it "persists the teammate id" do
      task.teammate = create(:teammate, id: "tm4")
      accessor.save(task)
      expect(redis.hgetall("Task:1")["teammate_id"]).to eq("tm4")
    end
  end
end
