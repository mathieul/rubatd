module Rubatd
  class TaskQueue < Model
    attribute :name, String
    attribute :team, Team

    def validate
      assert_present :name
      assert_present :team
      assert team.is_a?(Team), [:team, :not_a_team]
    end

    def add_task(task)
      task.queued_at = Time.now
      task.task_queue = self
    end
  end
end
