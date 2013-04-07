require "spec_helper"

include Rubatd

describe Skill do
  context "model attributes" do
    it "is valid with valid attributes" do
      expect(build(:skill)).to be_valid
    end

    it "is not valid without a name" do
      expect(build(:skill, name: nil)).not_to be_valid
    end

    it "is not valid without a team" do
      skill = build(:skill, team: nil)
      expect(skill).not_to be_valid
      expect(skill.errors[:team]).to eq([:not_present, :not_a_team])
    end

    it "is not valid without a teammate" do
      skill = build(:skill, teammate: nil)
      expect(skill).not_to be_valid
      expect(skill.errors[:teammate]).to eq([:not_present, :not_a_teammate])
    end

    it "is not valid without a queue" do
      skill = build(:skill, task_queue: nil)
      expect(skill).not_to be_valid
      expect(skill.errors[:task_queue]).to eq([:not_present, :not_a_task_queue])
    end
  end
end
