require "workflow"

module Rubatd
  class Teammate < Model
    include Workflow

    attribute :name, String
    attribute :team, Team

    workflow do
      state :signed_out do
        event :sign_in,   :transitions_to => :on_break
      end
      state :on_break do
        event :sign_out,  :transitions_to => :signed_out
        event :get_ready, :transitions_to => :available
      end
      state :available
    end

    def validate
      assert_present :name
      assert_present :team
      assert team.is_a?(Team), [:team, :not_a_team]
    end
  end
end
