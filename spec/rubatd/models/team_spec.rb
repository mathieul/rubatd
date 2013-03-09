require "spec_helper"

include Rubatd

describe Team do
  it "is valid with valid attributes" do
    expect(Team.new(valid_attributes)).to be_valid
  end

  it "is not valid without a name" do
    team = Team.new(valid_attributes.except(:name))
    expect(team).not_to be_valid
  end

  let(:valid_attributes) { {name: "valid name"} }
end
