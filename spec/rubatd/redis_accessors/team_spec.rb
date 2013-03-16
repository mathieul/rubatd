require "spec_helper"

include Rubatd

describe RedisAccessors::Team do
  let(:accessor) do
    RedisAccessors::Team.new(Redis.new(redis_config))
  end

  it "is a redis accessor" do
    expect(accessor).to be_an(RedisAccessors::Base)
  end
end
