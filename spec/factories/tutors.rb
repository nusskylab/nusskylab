FactoryGirl.define do
  factory :tutor do
    user nil
    cohort Time.now.year
  end
end
