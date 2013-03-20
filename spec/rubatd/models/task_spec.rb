require "spec_helper"

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
  end
end
