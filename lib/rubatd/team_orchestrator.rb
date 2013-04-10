module Rubatd
  class TeamOrchestrator
    attr_reader :store, :distributor

    def initialize(store, distributor)
      @store       = store
      @distributor = distributor
    end

    def enqueue_task(queue, task)
      queue.enqueue(task)
      store.write(queue, task)
    end

    def dequeue_task(queue, task)
      queue.dequeue(task)
      store.write(queue, task)
    end

    def next_task(queue)
      store.collection(queue, :tasks).last
    end

    def make_available(teammate)
      return false unless teammate.get_ready!
      distributor.teammate_available(teammate)
      true
    end
  end
end
