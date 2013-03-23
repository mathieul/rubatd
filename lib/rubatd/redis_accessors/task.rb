module Rubatd
  module RedisAccessors
    class Task < Base
      references "Team"
      references "Queue"
      references "Teammate"
    end
  end
end
