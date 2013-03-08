class Team
  include Model

  attr_accessor :name

  def validate
    assert_present :name
  end
end
