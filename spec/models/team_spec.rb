require "spec_helper"

describe Team do
  it "is not valid without a name" do
    team = Team.new(valid_attributes.except(:name))
    expect(team).not_to be_valid
  end

  it "has a collection of teammates" do
    team = Team.create(valid_attributes)
    %w[one two three].each { |name| Teammate.create(name: name, team: team) }
    expect(team).to have(3).teammates
  end

  let(:valid_attributes) { {name: "valid name"} }
end
