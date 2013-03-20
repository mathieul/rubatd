module Rubatd
  module RedisAccessors
    class Skill < Base
      reference "Team"
      reference "Teammate"
      reference "Queue"
    end
  end
end
