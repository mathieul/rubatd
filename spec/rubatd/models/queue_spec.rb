require "spec_helper"

include Rubatd

describe Queue do
  context "model attributes" do
    it "is valid with valid attributes" do
      expect(build(:queue)).to be_valid
    end

    it "is not valid without a name" do
      expect(build(:queue, name: nil)).not_to be_valid
    end

    it "is not valid without a persisted team" do
      queue = build(:queue, team: nil)
      expect(queue).not_to be_valid
      expect(queue.errors).to eq(team: [:not_present, :not_a_team])
      queue.team = build(:team)
      expect(queue).not_to be_valid
      expect(queue.errors).to eq(team: [:not_persisted])
    end
  end

  context "queueing tasks" do
    let(:task) { create(:task) }
    let(:queue) { create(:queue) }

    it "can enqueue a task with #enqueue" do
      queue.enqueue(task)
      expect(queue.enqueued_tasks).to eq([task])
    end

    it "can dequeue a task with #dequeue" do
      queue.dequeue(task)
      expect(queue.dequeued_tasks).to eq([task])
    end

    it "removes enqueued tasks if necessary with #dequeue" do
      queue.enqueue(task)
      queue.dequeue(task)
      expect(queue.enqueued_tasks).to be_empty
    end

    it "removes dequeued tasks if necessary with #enqueue" do
      queue.dequeue(task)
      queue.enqueue(task)
      expect(queue.dequeued_tasks).to be_empty
    end
  end
end
