require "spec_helper"

include Rubatd

module DataStoreHelpers
  class Singer
    def type_name
      "Singer"
    end
  end
  class Song
    def type_name
      "Song"
    end
  end
end

Rubatd::RedisAccessors::Singer = Struct.new(:model, :db)
Rubatd::RedisAccessors::Song = Struct.new(:model, :db)

describe DataStore do
  let(:store) { DataStore.new(:redis, Redis, redis_config) }

  it "is initialized for a database" do
    expect(store.db).to be_a(Redis)
  end

  it "delegates #save to the appropriate redis accessor" do
    model1 = DataStoreHelpers::Singer.new
    model2 = DataStoreHelpers::Song.new
    Rubatd::RedisAccessors::Singer.any_instance.should_receive(:save).with(model1)
    Rubatd::RedisAccessors::Song.any_instance.should_receive(:save).with(model2)

    store.save(model1, model2)
  end

  it "delegates #delete to the appropriate redis accessor" do
    model = DataStoreHelpers::Singer.new
    Rubatd::RedisAccessors::Singer.any_instance.should_receive(:delete).with(model)

    store.delete(model)
  end

  it "delegates #get(:model, id) to the appropriate redis accessor" do
    Rubatd::RedisAccessors::Singer.any_instance
      .should_receive(:get).with("42").and_return(:found)

    model = store.get(:singer, id: "42")

    expect(model).to eq(:found)
  end

  it "delegates #get(model, :referrers) to the appropriate redis accessor" do
    referee = DataStoreHelpers::Singer.new
    referee.should_receive(:id).and_return("42")
    Rubatd::RedisAccessors::Singer.any_instance
      .should_receive(:referrers).with("Song", "42").and_return([:found])

    referrers = store.get(referee, referrers: :song)

    expect(referrers).to eq([:found])
  end

  it "delegates #get(model, :embedded) to the appropriate redis accessor" do
    pending
  end
end
