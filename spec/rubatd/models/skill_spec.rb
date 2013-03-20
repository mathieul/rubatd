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
      expect(skill.errors).to eq(team: [:not_present, :not_a_team])
      skill.team = build(:team)
      expect(skill).not_to be_valid
      expect(skill.errors).to eq(team: [:not_persisted])
    end
  end
end
