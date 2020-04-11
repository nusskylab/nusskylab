FactoryGirl.define do
  factory :mentor do
    user
    cohort Time.now.year
  end
end
