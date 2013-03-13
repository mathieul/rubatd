module Rubatd
  module Accessors
    class RedisTeammate < RedisBase
      def attributes(model)
        attributes = model.attributes.except("team")
        attributes.merge("team_id" => model.team && model.team.id)
      end
    end
  end
end
