module Rubatd
  module RedisAccessors
    class Queue < Base
      references "Team"
      embeds :tasks do |model, key|
        to_add = model.enqueued_tasks.map { |task| [task.created_ts, task.id] }.flatten
        key.zadd(to_add) unless to_add.empty?
        to_del = model.dequeued_tasks.map(&:id)
        key.zrem(to_del) unless to_del.empty?
      end
    end
  end
end
