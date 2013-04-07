require "acceptance_helper"

feature "Provisioning objects" do
  let(:store) { Rubatd::DataStore.new(:redis, Redis, redis_config) }

  scenario "Create team, teammates and queues" do
    the_advisors = Rubatd::Team.new(name: "Advisors")
    store.write(the_advisors)
    teammate = Rubatd::Teammate.new(name: "mathieu", team: the_advisors)
    store.write(teammate)

    mathieu = store.read(:teammate, teammate.uid)
    referrers = store.collection(the_advisors, :teammates).all
    expect(referrers.map(&:name)).to eq(["mathieu"])

    store.erase(mathieu)
    expect { store.read(:teammate, mathieu.uid) }.to raise_error(Redistent::ModelNotFound)
  end

  scenario "Retrieve tasks queued" do
    pending
    store.write(team = Rubatd::Team.new(name: "Ze Team"))

    store.write(queue = Rubatd::Queue.new(name: "Ze Queue", team: team))
    store.write(buy_milk = Rubatd::Task.new(title: "Buy the milk", team: team))
    store.write(do_homework = Rubatd::Task.new(title: "Do my homework", team: team))

    orchestrator = Rubatd::TeamOrchestrator.new(store)
    orchestrator.enqueue_task(queue, do_homework)
    orchestrator.enqueue_task(queue, buy_milk)

    # num_tasks = store.get(queue, embedded: :tasks) { |tasks| tasks.count }
    # expect(num_tasks).to eq(2)
    # next_id = store.get(queue, embedded: :tasks) { |tasks| tasks.next_id }
    # expect(next_id).to eq(buy_milk.id)

    # class Queue
    #   embeds :tasks, score: ->(task) { task.created_ts } do
    #     # key = "Queue:123:task_ids"
    #     define(:count)   { |key| key.zcard }
    #     define(:next_id) { |key| key.command(...read next id...) }
    #   end
    # end
    #
    # class Teammate
    # end
    #
    # class Skill
    #   references :teammate do
    #     # key = "Skill:indices:teammate_id"
    #     save { |model, key|
    #       # "#{key}:old123": srem model.id
    #       # "#{key}:new456": sadd model.id
    #     }
    #     del { |model, key| # "#{key}:id789": srem model.id }
    #   end
    #   references :queue
    # end

    # store.save(queue, task)
    # store.get(:queue, queue_id) # any reference is instantiated?
    # store.delete(task)

    # store.referenced_by(queue).skills.all
    # store.embedded_in(queue).tasks << task
    # store.embedded_in(queue).tasks.count
    # store.embedded_in(queue).tasks.next_id

  end
end
