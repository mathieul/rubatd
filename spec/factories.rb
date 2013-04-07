store = begin
  config = GlobalConfigHelpers.instance_method(:redis_config).bind(self).call
  Rubatd::DataStore.new(config)
end

FactoryGirl.define do
  to_create { |instance| store.write(instance) }

  factory :team, class: Rubatd::Team do
    name "valid team"
  end

  factory :teammate, class: Rubatd::Teammate do
    name "valid teammate"
    team
  end

  factory :task_queue, class: Rubatd::TaskQueue do
    name "valid task queue"
    team
  end

  factory :task, class: Rubatd::Task do
    title "valid task"
    team
  end

  factory :skill, class: Rubatd::Skill do
    name "valid skill"
    team       { shared_team }
    task_queue { create(:task_queue, team: shared_team) }
    teammate   { create(:teammate,   team: shared_team) }

    ignore do
      shared_team { create(:team) }
    end
  end

  def store
    @store ||= Rubatd::DataStore.new(:redis, Redis, redis_config)
  end
end
