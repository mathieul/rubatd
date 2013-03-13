store = begin
  config = GlobalConfigHelpers.instance_method(:redis_config).bind(self).call
  Rubatd::DataStore.new(:redis, Redis, config)
end

FactoryGirl.define do
  to_create { |instance| store.save(instance) }

  factory :team, class: Rubatd::Team do
    name "valid team"
  end

  factory :teammate, class: Rubatd::Teammate do
    name "valid teammate"
    team
  end


  def store
    @store ||= Rubatd::DataStore.new(:redis, Redis, redis_config)
  end
end