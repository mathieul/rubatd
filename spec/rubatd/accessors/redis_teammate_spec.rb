require "spec_helper"

include Rubatd

describe Accessors::RedisTeammate do
  let(:accessor) do
    Accessors::RedisTeammate.new(build(:teammate), Redis.new(redis_config))
  end

  it "is a redis accessor" do
    expect(accessor).to be_an(Accessors::RedisBase)
  end
end
