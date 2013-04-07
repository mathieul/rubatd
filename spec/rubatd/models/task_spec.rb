require "spec_helper"
require "timecop"

include Rubatd

describe Task do
  context "model attributes" do
    it "is valid with valid attributes" do
      expect(build(:task)).to be_valid
    end

    it "is not valid without a title" do
      expect(build(:task, title: nil)).not_to be_valid
    end

    it "is not valid without a team" do
      task = build(:task, team: nil)
      expect(task).not_to be_valid
      expect(task.errors).to eq(team: [:not_present, :not_a_team])
    end

    it "can reference a queue" do
      task = create(:task)
      task.task_queue = queue = create(:queue)
      expect(task.task_queue).to eq(queue)
    end

    it "can reference a teammate" do
      task = create(:task)
      task.teammate = teammate = create(:teammate)
      expect(task.teammate).to eq(teammate)
    end

    it "can have a 'queued at' timestamp" do
      Timecop.travel Time.local(2013, 3, 9, 22, 25, 10, 42) do
        task = build(:task, queued_at: Time.now)
        expect(task.queued_at.to_f).to be_within(0.1).of(1362896710.000042)
      end
    end
  end
end
