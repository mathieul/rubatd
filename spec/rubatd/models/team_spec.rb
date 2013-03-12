require "spec_helper"

include Rubatd

describe Team do
  it "is valid with valid attributes" do
    expect(build(:team)).to be_valid
  end

  it "is not valid without a name" do
    expect(build(:team, name: nil)).not_to be_valid
  end
end
