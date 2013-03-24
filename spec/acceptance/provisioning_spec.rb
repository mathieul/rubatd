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
