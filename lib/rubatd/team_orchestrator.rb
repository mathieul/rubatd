module Rubatd
  class TeamOrchestrator
    attr_reader :store

    def initialize(store)
      @store = store
    end

    def enqueue_task(queue, task)
      queue.enqueue(task)
      store.write(queue, task)
    end

    def dequeue_task(queue, task)
      queue.dequeue(task)
      store.write(queue, task)
    end
  end
end
