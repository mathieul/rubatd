require "spec_helper"

include Rubatd

describe TaskQueue do
  context "model attributes" do
    it "is valid with valid attributes" do
      expect(build(:task_queue)).to be_valid
    end

    it "is not valid without a name" do
      expect(build(:task_queue, name: nil)).not_to be_valid
    end

    it "is not valid without a team" do
      queue = build(:task_queue, team: nil)
      expect(queue).not_to be_valid
      expect(queue.errors).to eq(team: [:not_present, :not_a_team])
    end
  end

  context "queueing tasks" do
    let(:task) { create(:task) }
    let(:queue) { create(:task_queue) }

    it "can enqueue a task with #enqueue" do
      queue.enqueue(task)
      expect(task.task_queue).to eq(queue)
      expect(task.queued_at).to be_within(0.01).of(Time.now)
    end

    it "can dequeue a task with #dequeue" do
      queue.dequeue(task)
      expect(task.task_queue).to be_nil
    end
  end
end
