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

    it "is not valid without a persisted team" do
      task = build(:task, team: nil)
      expect(task).not_to be_valid
      expect(task.errors).to eq(team: [:not_present, :not_a_team])
      task.team = build(:team)
      expect(task).not_to be_valid
      expect(task.errors).to eq(team: [:not_persisted])
    end

    it "can reference a queue" do
      task = create(:task)
      task.queue = queue = create(:queue)
      expect(task.queue).to eq(queue)
    end

    it "can reference a teammate" do
      task = create(:task)
      task.teammate = teammate = create(:teammate)
      expect(task.teammate).to eq(teammate)
    end

    it "has a created timestamp" do
      Timecop.travel Time.local(2013, 3, 9, 22, 25, 10, 42)
      task = build(:task)
      expect(task.created_ts.to_f).to be_within(0.1).of(1362896710.000042)
      Timecop.return
    end
  end
end
