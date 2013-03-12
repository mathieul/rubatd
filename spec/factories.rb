FactoryGirl.define do

  skip_create

  factory :team, class: Rubatd::Team do
    name "valid team"
  end

  factory :teammate, class: Rubatd::Teammate do
    name "valid teammate"
    team
  end

end
