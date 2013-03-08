class Teammate
  include Model

  attr_accessor :name

  def validate
    assert_present :name
    assert_present :team
  end
end
