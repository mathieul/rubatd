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

  it "#create generates a model id and saves the model" do
    Rubatd::Accessors::RedisDSModel.any_instance.should_receive(:generate_model_id)
    Rubatd::Accessors::RedisDSModel.any_instance.should_receive(:save)
    store.create(DSModel.new)
  end
end
