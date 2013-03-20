require "spec_helper"

include Rubatd

describe Teammate do
  it "is valid with valid attributes" do
    expect(build(:teammate)).to be_valid
  end

  it "is not valid without a name" do
    expect(build(:teammate, name: nil)).not_to be_valid
  end

  it "is not valid without a team" do
    teammate = build(:teammate, team: nil)
    expect(teammate).not_to be_valid
    expect(teammate.errors).to eq(team: [:not_present, :not_a_team])
    teammate.team = :something_other_than_a_team
    expect(teammate).not_to be_valid
    expect(teammate.errors).to eq(team: [:not_a_team])
  end

  it "is not valid if its team is not valid" do
    teammate = build(:teammate, team: build(:team))
    expect(teammate).not_to be_valid
  end
end
