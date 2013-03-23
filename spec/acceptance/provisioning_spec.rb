require "acceptance_helper"

feature "Provisioning objects" do
  let(:store) { Rubatd::DataStore.new(:redis, Redis, redis_config) }

  scenario "Create team, teammates and queues" do
    the_advisors = Rubatd::Team.new(name: "Advisors")
    store.save(the_advisors)
    teammate = Rubatd::Teammate.new(name: "mathieu", team: the_advisors)
    store.save(teammate)

    mathieu = store.get(:teammate, id: teammate.id)
    referrers = store.get(the_advisors, referrers: :teammate)
    expect(referrers.map(&:name)).to eq([mathieu.name])

    store.delete(mathieu)
    expect { store.get(:teammate, id: mathieu.id) }.to raise_error(Rubatd::ModelNotFound)
  end

  scenario "Retrieve tasks queued" do
    store.save(team = Rubatd::Team.new(name: "Ze Team"))

    store.save(queue = Rubatd::Queue.new(name: "Ze Queue", team: team))
    store.save(buy_milk = Rubatd::Task.new(title: "Buy the milk", team: team))
    store.save(do_homework = Rubatd::Task.new(title: "Do my homework", team: team))

    orchestrator = Rubatd::TeamOrchestrator.new(store)
    orchestrator.enqueue_task(queue, do_homework)
    orchestrator.enqueue_task(queue, buy_milk)
    next_id = store.get(queue, embedded: :tasks) { |tasks| tasks.next_id }
    next_task = store.get(:task, next_id)
    expect(next_task.title).to eq("Buy the milk")
  end
end
