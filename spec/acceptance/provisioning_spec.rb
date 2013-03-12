require "acceptance_helper"

include Rubatd

feature "Provisioning objects" do
  scenario "Create team, teammates and queues" do
    store = DataStore.new(:redis, Redis, redis_config)
    the_advisors = Team.new(name: "Advisors")
    store.save(the_advisors)
    mathieu = Teammate.new(name: "mathieu", team: the_advisors)
    store.save(mathieu)
  end
end
