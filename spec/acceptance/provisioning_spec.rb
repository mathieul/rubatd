require "acceptance_helper"

include Rubatd

feature "Provisioning objects" do
  scenario "Create team, teammates and queues" do
    store = DataStore.new(:redis, Redis, redis_config)
    the_advisors = Team.new(name: "Advisors")
    store.save(the_advisors)
    teammate = Teammate.new(name: "mathieu", team: the_advisors)
    store.save(teammate)

    mathieu = store.get(:teammate, teammate.id)
    referrers = store.get(the_advisors, :teammate)
    expect(referrers.map(&:name)).to eq([mathieu.name])
  end
end
