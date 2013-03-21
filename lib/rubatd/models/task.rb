module Rubatd
  class Task < Model
    attr_accessor :title, :created_ts, :team, :queue, :teammate

    def post_initialize(attributes)
      self.created_ts ||= make_created_ts
    end

    def validate
      assert_present :title
      assert_present :team
      assert team.is_a?(Team), [:team, :not_a_team]
      assert team.persisted?, [:team, :not_persisted] if team.respond_to?(:persisted?)
    end

    private

    def make_created_ts
      Time.now.to_f.to_s
    end
  end
end
