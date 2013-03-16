module Rubatd
  module RedisAccessors
    class Teammate < Base
      reference "Team"

      def attributes(model)
        attributes = model.attributes.except("team")
        attributes.merge("team_id" => model.team && model.team.id)
      end
    end
  end
end
