module Rubatd
  class Skill < Model
    attr_accessor :name, :team

    def validate
      assert_present :name
      assert_present :team
      assert team.is_a?(Team), [:team, :not_a_team]
      assert team.persisted?, [:team, :not_persisted] if team.respond_to?(:persisted?)
    end
  end
end
