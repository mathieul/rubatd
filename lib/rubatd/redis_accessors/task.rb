module Rubatd
  module RedisAccessors
    class Task < Base
      reference "Team"
      reference "Queue"
      reference "Teammate"
    end
  end
end
