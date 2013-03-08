require "spec_helper"

describe Team do
  it "is valid with valid attributes" do
    expect(Team.new(valid_attributes)).to be_valid
  end

  it "has an id" do
    expect(Team.new.id).to be_a(String)
    expect(Team.new(id: "blah").id).to eq("blah")
  end

  it "is not valid without a name" do
    team = Team.new(valid_attributes.except(:name))
    expect(team).not_to be_valid
  end

  it "has a collection of teammates" do
    team = Team.new(valid_attributes)
    %w[one two three].each { |name| Teammate.new(name: name, team: team) }
    expect(team).to have(3).teammates
  end

  let(:valid_attributes) { {name: "valid name"} }
end
