require "acceptance_helper"

feature "Provisioning objects" do
  scenario "Create team, teammates and queues" do
    store = DataStore.new(data_store_config)
    the_advisors = Team.new(name: "Advisors")
    store.save(the_advisors)
    mathieu = Teammate.new(name: "mathieu", team: the_advisors)
    store.save(mathieu)
  end
end
