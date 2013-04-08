require "spec_helper"

include Rubatd

describe TeamOrchestrator do
  let(:store) { double(:store) }
  let(:queue) { double(:queue) }
  let(:task) { double(:task) }
  let(:orchestrator) { TeamOrchestrator.new(store) }

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

  it "makes a teammate available with #make_available"

  it "makes a teammate accept a task with #accept_task"

  it "makes a teammate reject a task with #reject_task"

  it "makes a teammate finish a task with #finish_task"
end
