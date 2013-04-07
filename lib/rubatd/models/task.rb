module Rubatd
  class Task < Model
    attribute :title,      String
    attribute :queued_at,  Time
    attribute :team,       Team
    attribute :task_queue, TaskQueue
    attribute :teammate,   Teammate

    def validate
      assert_present :title
      assert_present :team
      assert team.is_a?(Team), [:team, :not_a_team]
    end
  end
end
