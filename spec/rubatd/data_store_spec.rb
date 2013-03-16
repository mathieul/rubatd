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

describe DataStore do
  let(:store) { DataStore.new(:redis, Redis, redis_config) }

  it "is initialized for a database" do
    expect(store.db).to be_a(Redis)
  end

  it "delegates #save to the appropriate redis accessor" do
    model = DataStoreHelpers::Singer.new
    Rubatd::RedisAccessors::Singer.any_instance.should_receive(:save).with(model)
    store.save(model)
  end

  it "delegates #get to the appropriate redis accessor" do
    Rubatd::RedisAccessors::Singer.any_instance
      .should_receive(:get).with("42").and_return(:found)
    model = store.get("Singer", "42")
    expect(model).to eq(:found)
  end

  it "delegates #fetch_referrers to the appropriate redis accessor" do
    referee = DataStoreHelpers::Singer.new
    referee.should_receive(:id).and_return("42")
    Rubatd::RedisAccessors::Singer.any_instance
      .should_receive(:referrers).with("Song", "42").and_return([:found])
    referrers = store.fetch_referrers(referee, "Song")
    expect(referrers).to eq([:found])
  end
end
