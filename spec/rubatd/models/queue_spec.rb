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
end
