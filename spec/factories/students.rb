FactoryGirl.define do
  factory :student do
    user
    team
    is_pending false
    cohort Time.now.year
  end
end
