module Rubatd
  class Task < Model
    attr_accessor :title, :team

    def validate
      assert_present :title
      assert_present :team
      assert team.is_a?(Team), [:team, :not_a_team]
      assert team.persisted?, [:team, :not_persisted] if team.respond_to?(:persisted?)
    end
  end
end
