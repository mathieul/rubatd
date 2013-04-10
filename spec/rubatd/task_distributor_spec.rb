require "spec_helper"

include Rubatd

describe TaskDistributor do
  let(:team)        { double(:team) }
  let(:teammate)    { double(:teammate) }
  let(:queues)      { double(:queues) }
  let(:queue)       { double(:queue) }
  let(:tasks)       { double(:tasks) }
  let(:task)        { double(:task) }
  let(:store)       { double(:store) }
  let(:distributor) { TaskDistributor.new }

  context "#teammate_available" do
    it "assigns a task to the teammate if one is available" do
      store.should_receive(:collection).with(team, :queues).and_return(queues)
      queues.should_receive(:all).with(using: :is_ready).and_return([queue])
      store.should_receive(:collection).with(queue, :tasks).and_return(tasks)
      tasks.should_receive(:last).and_return(task)
      teammate.should_receive(:assign).with(task)
      store.should_receive(:write).with(teammate)
      distributor.teammate_available(store, teammate)
    end
  end
end
