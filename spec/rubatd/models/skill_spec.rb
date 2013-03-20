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
      expect(skill.errors).to eq(team: [:not_present, :not_a_team])
      skill.team = :something_other_than_a_team
      expect(skill).not_to be_valid
      expect(skill.errors).to eq(team: [:not_a_team])
    end

    it "is not valid if its team is not valid" do
      skill = build(:skill, team: build(:team))
      expect(skill).not_to be_valid
    end
  end
end
