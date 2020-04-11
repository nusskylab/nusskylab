FactoryGirl.define do
  factory :milestone do
    name 'Milestone 1'
    submission_deadline Time.now
    peer_evaluation_deadline Time.now
    cohort Time.now.year
  end
end
