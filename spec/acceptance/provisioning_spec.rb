require "acceptance_helper"

feature "Provisioning objects" do
  scenario "Create team, teammates and queues" do
    advisors_team = Team.create(name: "Advisors")
    expect(advisors_team).to be_valid
    teammate = Teammate.create(name: "mathieu", team: advisors_team)
    expect(teammate).to be_valid
  end
end