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

    it "is not valid without a persisted team" do
      skill = build(:skill, team: nil)
      expect(skill).not_to be_valid
      expect(skill.errors[:team]).to eq([:not_present, :not_a_team])
      skill.team = build(:team)
      expect(skill).not_to be_valid
      expect(skill.errors[:team]).to eq([:not_persisted])
    end

    it "is not valid without a persisted teammate" do
      skill = build(:skill, teammate: nil)
      expect(skill).not_to be_valid
      expect(skill.errors[:teammate]).to eq([:not_present, :not_a_teammate])
      skill.teammate = build(:teammate)
      expect(skill).not_to be_valid
      expect(skill.errors[:teammate]).to eq([:not_persisted])
    end

    it "is not valid without a persisted queue" do
      skill = build(:skill, queue: nil)
      expect(skill).not_to be_valid
      expect(skill.errors[:queue]).to eq([:not_present, :not_a_queue])
      skill.queue = build(:queue)
      expect(skill).not_to be_valid
      expect(skill.errors[:queue]).to eq([:not_persisted])
    end
  end
end
