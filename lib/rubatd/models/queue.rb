module Rubatd
  class Queue < Model
    attr_accessor :name, :team
    attr_reader :enqueued_tasks, :dequeued_tasks

    reserve_attributes :enqueued_tasks, :dequeued_tasks

    def post_initialize(attributes)
      @enqueued_tasks = []
      @dequeued_tasks = []
    end

    def validate
      assert_present :name
      assert_present :team
      assert team.is_a?(Team), [:team, :not_a_team]
      assert team.persisted?, [:team, :not_persisted] if team.respond_to?(:persisted?)
    end

    def enqueue(task)
      @dequeued_tasks.delete(task)
      @enqueued_tasks << task
    end

    def dequeue(task)
      @enqueued_tasks.delete(task)
      @dequeued_tasks << task
    end
  end
end
