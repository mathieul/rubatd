module Rubatd
  module RedisAccessors
    class Skill < Base
      references "Team"
      references "Teammate"
      references "Queue"
    end
  end
end
