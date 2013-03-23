module Rubatd
  module RedisAccessors
    class Teammate < Base
      references "Team"
    end
  end
end
