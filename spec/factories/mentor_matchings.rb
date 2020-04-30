FactoryGirl.define do
  factory :mentor_matching do
    team
    mentor
    choice_ranking 1
    mentor_accepted false
    cohort Time.now.year
  end
end
