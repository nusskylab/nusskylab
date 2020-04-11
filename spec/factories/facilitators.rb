FactoryGirl.define do
  factory :facilitator do
    user nil
    cohort Time.now.year
  end
end
