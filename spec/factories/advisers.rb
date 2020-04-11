FactoryGirl.define do
  factory :adviser do
    user
    cohort Time.now.year
  end
end
