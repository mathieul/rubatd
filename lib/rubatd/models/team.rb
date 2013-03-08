require "Scrivener"

class Team
  include Model
  include Scrivener::Validations

  attr_accessor :name

  def validate
    assert_present :name
  end
end
