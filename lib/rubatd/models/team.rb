class Team < Ohm::Model
  attribute  :name
  collection :teammates, :Teammate

  def validate
    assert_present :name
  end
end
