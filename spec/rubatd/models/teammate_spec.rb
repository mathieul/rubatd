require "spec_helper"

include Rubatd

describe Teammate do
  context "model attributes" do
    it "is valid with valid attributes" do
      expect(build(:teammate)).to be_valid
    end

    it "is not valid without a name" do
      expect(build(:teammate, name: nil)).not_to be_valid
    end

    it "is not valid without a persisted team" do
      teammate = build(:teammate, team: nil)
      expect(teammate).not_to be_valid
      expect(teammate.errors).to eq(team: [:not_present, :not_a_team])
      teammate.team = build(:team)
      expect(teammate).not_to be_valid
      expect(teammate.errors).to eq(team: [:not_persisted])
    end
  end

  context "states" do
    let(:teammate) { Teammate.new }

    it "is signed out by default" do
      expect(teammate).to be_signed_out
    end

    it "can sign in" do
      teammate.sign_in!
      expect(teammate).to be_on_break
    end

    it "can sign out" do
      teammate.sign_in!
      teammate.sign_out!
      expect(teammate).to be_signed_out
    end

    it "can get ready" do
      teammate.sign_in!
      teammate.get_ready!
      expect(teammate).to be_available
    end
  end
end
