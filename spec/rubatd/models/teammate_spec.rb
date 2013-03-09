require "spec_helper"

include Rubatd

describe Teammate do
  it "is valid with valid attributes" do
    expect(Teammate.new(valid_attributes)).to be_valid
  end

  it "is not valid without a name" do
    teammate = Teammate.new(valid_attributes.except(:name))
    expect(teammate).not_to be_valid
  end

  it "is not valid without a team" do
    teammate = Teammate.new(valid_attributes.except(:team))
    expect(teammate).not_to be_valid
    expect(teammate.errors).to eq(team: [:not_present, :not_a_team])
    teammate.team = :something_other_than_a_team
    expect(teammate).not_to be_valid
    expect(teammate.errors).to eq(team: [:not_a_team])
  end

  let(:valid_attributes) { {name: "valid name", team: team} }
  let(:team) { Team.new(name: "ze team") }
end
