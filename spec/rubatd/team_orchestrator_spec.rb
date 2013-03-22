require "spec_helper"

include Rubatd

describe TeamOrchestrator do
  let(:store) { double(:store) }
  let(:queue) { double(:queue) }
  let(:task) { double(:task) }
  let(:orchestrator) { TeamOrchestrator.new(store) }

  it "enqueues a task with #enqueue_task" do
    task.should_receive(:queue=).with(queue)
    queue.should_receive(:enqueue).with(task)
    store.should_receive(:save).with(queue, task)
    orchestrator.enqueue_task(queue, task)
  end
end
