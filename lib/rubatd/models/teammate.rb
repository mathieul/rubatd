module Rubatd
  class Teammate < Model
    attr_accessor :name, :team_id

    def validate
      assert_present :name
      assert_present :team_id
    end
  end
end
