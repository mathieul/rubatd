require "Scrivener"

class Teammate
  include Model
  include Scrivener::Validations

  attr_accessor :name

  def validate
    assert_present :name
    assert_present :team
  end
end
