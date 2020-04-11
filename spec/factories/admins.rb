FactoryGirl.define do
  factory :admin do
    user
    cohort Time.now.year
  end
end
