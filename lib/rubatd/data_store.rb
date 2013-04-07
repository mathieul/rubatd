require "redistent"

class Rubatd::DataStore
  include Redistent::Accessor

  before_write :assert_valid!

  namespace Rubatd

  model :team

  model :teammate do
    references :team
    collection :skills
    collection :task_queues, via: :skills
  end

  model :task_queue do
    references :team
    collection :tasks, sort_by: :queued_at
    collection :skills
    collection :teammates, via: :skills
  end

  model :skill do
    references :team
    references :teammate
    references :task_queue
  end

  model :task do
    references :team
    references :task_queue
  end
end
