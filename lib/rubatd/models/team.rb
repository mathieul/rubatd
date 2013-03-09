module Rubatd
  class Team < Model
    attr_accessor :name

    def validate
      assert_present :name
    end
  end
end
