require "spec_helper"

include Rubatd

class DSModel
  def type_name
    "DSModel"
  end
end

Rubatd::Accessors::RedisDSModel = Struct.new(:model, :db)

describe DataStore do
  let(:store) { DataStore.new(:redis, Redis, redis_config) }

  it "is initialized for a database" do
    expect(store.db).to be_a(Redis)
  end

  it "#save delegates to the appropriate redis accessor" do
    model = DSModel.new
    Rubatd::Accessors::RedisDSModel.any_instance.should_receive(:save).with(model)
    store.save(model)
  end

  it "#find delegates to teh appropriate redis accessor" do
    Rubatd::Accessors::RedisDSModel.any_instance
      .should_receive(:[]).with("42").and_return(:found)
    model = store["DSModel"]["42"]
    expect(model).to eq(:found)
  end
end
