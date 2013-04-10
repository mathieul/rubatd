require "acceptance_helper"

feature "Provisioning objects" do
  let(:store) { Rubatd::DataStore.new(redis_config) }

  scenario "Create team, teammates and queues" do
    the_advisors = Rubatd::Team.new(name: "Advisors")
    store.write(the_advisors)
    teammate = Rubatd::Teammate.new(name: "mathieu", team: the_advisors)
    store.write(teammate)

    mathieu = store.read(:teammate, teammate.uid)
    teammates = store.collection(the_advisors, :teammates).all
    expect(teammates.map(&:name)).to eq(["mathieu"])

    store.erase(mathieu)
    expect { store.read(:teammate, mathieu.uid) }.to raise_error(Redistent::ModelNotFound)
  end

  scenario "Queue and access tasks" do
    store.write(
      team = Rubatd::Team.new(name: "Ze Team"),
      queue = Rubatd::TaskQueue.new(name: "Ze Queue", team: team),
      buy_milk = Rubatd::Task.new(title: "Buy the milk", team: team),
      do_homework = Rubatd::Task.new(title: "Do my homework", team: team)
    )

    distributor = Rubatd::TaskDistributor.new
    orchestrator = Rubatd::TeamOrchestrator.new(store, distributor)
    orchestrator.enqueue_task(queue, do_homework)
    orchestrator.enqueue_task(queue, buy_milk)

    queue_tasks = store.collection(queue, :tasks)
    expect(queue_tasks.count).to eq(2)
    expect(orchestrator.next_task(queue).uid).to eq(buy_milk.uid)
  end
end
