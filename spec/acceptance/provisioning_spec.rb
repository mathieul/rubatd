require "acceptance_helper"

include Rubatd

feature "Provisioning objects" do
  scenario "Create team, teammates and queues" do
    store = DataStore.new(:redis, Redis, redis_config)
    the_advisors = Team.new(name: "Advisors")
    store.create(the_advisors)
    mathieu = Teammate.new(name: "mathieu", team_id: the_advisors.id)
    store.create(mathieu)
  end
end
