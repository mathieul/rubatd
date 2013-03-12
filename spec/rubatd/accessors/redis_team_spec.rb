require "spec_helper"

include Rubatd

describe Accessors::RedisTeam do
  let(:team) { Team.new }
  let(:accessor) { Accessors::RedisTeam.new(team, Redis.new(redis_config)) }

  context "#save" do
    pending
  end
end
