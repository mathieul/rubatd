require "spec_helper"

include Rubatd

describe Teammate do
  it "is valid with valid attributes" do
    expect(Teammate.new(valid_attributes)).to be_valid
  end

  it "has an id" do
    expect(Teammate.new.id).to be_a(String)
    expect(Teammate.new(id: "blah").id).to eq("blah")
  end

  it "is not valid without a name" do
    teammate = Teammate.new(valid_attributes.except(:name))
    expect(teammate).not_to be_valid
  end

  it "is not valid without a team id" do
    teammate = Teammate.new(valid_attributes.except(:team_id))
    expect(teammate).not_to be_valid
  end

  let(:valid_attributes) { {name: "valid name", team_id: "123abc"} }
end
