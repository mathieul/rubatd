require "spec_helper"

include Rubatd

describe DataStore do
  let(:store) { DataStore.new(redis_config) }

  it "is a redistent accessor" do
    expect(store).to be_a_kind_of(Redistent::Accessor)
  end
end
