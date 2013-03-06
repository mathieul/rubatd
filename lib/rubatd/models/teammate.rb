class Teammate < Ohm::Model
  attribute  :name
  reference :team, :Team

  def validate
    assert_present :name
    assert_present :team
  end
end
