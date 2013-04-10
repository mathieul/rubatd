require "spec_helper"

include Rubatd

describe TeamOrchestrator do
  let(:store)        { double(:store) }
  let(:queue)        { double(:queue) }
  let(:task)         { double(:task) }
  let(:teammate)     { double(:teammate) }
  let(:distributor)  { double(:distributor) }
  let(:orchestrator) { TeamOrchestrator.new(store, distributor) }

  context "queueing tasks" do
    it "enqueues a task with #enqueue_task" do
      queue.should_receive(:enqueue).with(task)
      store.should_receive(:write).with(queue, task)
      orchestrator.enqueue_task(queue, task)
    end

    it "dequeues a task with #dequeue_task" do
      queue.should_receive(:dequeue).with(task)
      store.should_receive(:write).with(queue, task)
      orchestrator.dequeue_task(queue, task)
    end

    it "returns the next task to assign with #next_task" do
      collection = double(:collection)
      store.should_receive(:collection)
        .with(queue, :tasks)
        .and_return(collection)
      collection.should_receive(:last).and_return(:next_task)
      expect(orchestrator.next_task(queue)).to eq(:next_task)
    end
  end

  context "#make_available" do
    it "makes a teammate available" do
      teammate.should_receive(:get_ready!).and_return(true)
      distributor.should_receive(:teammate_available).with(teammate)
      expect(orchestrator.make_available(teammate)).to be_true
    end

    it "doesn't notify the distributor if #get_ready fails" do
      teammate.should_receive(:get_ready!).and_return(false)
      distributor.should_not_receive(:teammate_available)
      expect(orchestrator.make_available(teammate)).to be_false
    end
  end

  it "makes a teammate accept a task with #accept_task"

  it "makes a teammate reject a task with #reject_task"

  it "makes a teammate finish a task with #finish_task"
end
