FactoryGirl.define do
  factory :student do
    user
    team
    application_status false
    cohort Time.now.year
  end
end
