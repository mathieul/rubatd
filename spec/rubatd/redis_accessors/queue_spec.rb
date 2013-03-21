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

  context "#save" do
    it "raises an error if team is not persisted" do
      queue.team = build(:team)
      expect { accessor.save(queue) }.to raise_error(ModelInvalid)
    end

    it "persists the team id" do
      accessor.save(queue)
      expect(redis.hgetall("Queue:1")["team_id"]).to eq("1")
    end

    it "adds the tasks enqueued to the sorted set of tasks" do
      queue.enqueue(task = create(:task, id: "t123"))
      accessor.save(queue)
      expect(redis.zrange("Queue:1:tasks", 0, -1)).to eq(["t123"])
    end

    it "removes the tasks dequeued from the sorted set of tasks" do
      queue.enqueue(task = create(:task, id: "t123"))
      accessor.save(queue)
      queue.dequeue(task)
      accessor.save(queue)
      expect(redis.zrange("Queue:1:tasks", 0, -1)).to eq([])
    end
  end

  context "#delete" do
    it "removes the sorted set of tasks of the queue" do
      queue.enqueue(task = create(:task, id: "t123"))
      accessor.save(queue)
      accessor.delete(queue)
      expect(redis.zrange("Queue:1:tasks", 0, -1)).to eq([])
    end
  end
end
