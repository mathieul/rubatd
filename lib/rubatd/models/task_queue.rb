module Rubatd
  class TaskQueue < Model
    attribute :name, String
    attribute :team, Team

    def validate
      assert_present :name
      assert_present :team
      assert team.is_a?(Team), [:team, :not_a_team]
    end

    def enqueue(task)
      task.queued_at = Time.now
      task.task_queue = self
    end

    def dequeue(task)
      task.task_queue = nil
    end
  end
end
