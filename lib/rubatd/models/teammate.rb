module Rubatd
  class Teammate < Model
    attr_accessor :name, :team

    def validate
      assert_present :name
      assert_present :team
      assert team.is_a?(Team), [:team, :not_a_team]
    end
  end
end
