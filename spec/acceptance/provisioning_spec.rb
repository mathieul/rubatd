require "acceptance_helper"

include Rubatd

feature "Provisioning objects" do
  let(:store) { DataStore.new(:redis, Redis, redis_config) }

  scenario "Create team, teammates and queues" do
    the_advisors = Team.new(name: "Advisors")
    store.save(the_advisors)
    teammate = Teammate.new(name: "mathieu", team: the_advisors)
    store.save(teammate)

    mathieu = store.get(:teammate, id: teammate.id)
    referrers = store.get(the_advisors, referrers: :teammate)
    expect(referrers.map(&:name)).to eq([mathieu.name])

    store.delete(mathieu)
    expect { store.get(:teammate, id: mathieu.id) }.to raise_error(ModelNotFound)
  end

  scenario "Retrieve tasks queued" do
    store.save(team = Team.new(name: "Ze Team"))
    manager = Team::Manager.new(team)

    store.save(queue = Queue.new(name: "Ze Queue", team: team))
    store.save(buy_milk = Task.new(title: "Buy the milk"))
    store.save(do_homework = Task.new(title: "Do my homework"))

    manager.enqueue_task(queue, do_homework)
    manager.enqueue_task(queue, buy_milk)
    tasks = store.get(queue, embedded: :tasks)
    expect(tasks.map(&:title)).to eq(["Buy the milk", "Do my homework"])
  end
end
