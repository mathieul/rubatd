module Rubatd
  module RedisAccessors
    class Queue < Base
      references "Team"

      embeds :tasks do
        event(:save) do |model, key|
          to_add = model.enqueued_tasks.map { |task| [task.created_ts, task.id] }.flatten
          key.zadd(to_add) unless to_add.empty?
          to_del = model.dequeued_tasks.map(&:id)
          key.zrem(to_del) unless to_del.empty?
        end

        define(:count)   { |key| key.zcard }
        define(:next_id) { |key| key.zrangebyscore("-inf", "+inf", limit: [0, 1]).first }
        end
      end
    end
  end
end
