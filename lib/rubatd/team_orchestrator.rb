module Rubatd
  class TeamOrchestrator
    attr_reader :store

    def initialize(store)
      @store = store
    end

    def enqueue_task(queue, task)
      task.queue = queue
      queue.enqueue(task)
      store.write(queue, task)
    end
  end
end
