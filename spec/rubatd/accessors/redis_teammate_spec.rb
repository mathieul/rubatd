require "spec_helper"

include Rubatd

describe Accessors::RedisTeammate do
  let(:teammate) { Teammate.new }
  let(:accessor) { Accessors::RedisTeammate.new(teammate, Redis.new(redis_config)) }

  context "#save" do
    pending
  end
end
