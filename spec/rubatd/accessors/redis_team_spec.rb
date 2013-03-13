require "spec_helper"

include Rubatd

describe Accessors::RedisTeam do
  let(:accessor) do
    Accessors::RedisTeam.new(Redis.new(redis_config))
  end

  it "is a redis accessor" do
    expect(accessor).to be_an(Accessors::RedisBase)
  end
end
