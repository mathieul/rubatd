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
end
