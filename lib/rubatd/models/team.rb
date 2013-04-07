module Rubatd
  class Team < Model
    attribute :name, String

    def validate
      assert_present :name
    end
  end
end
