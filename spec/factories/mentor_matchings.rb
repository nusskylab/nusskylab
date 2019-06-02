FactoryGirl.define do
    factory :mentor_matchings do
      team
      mentor
      choice_ranking 1
      mentor_accepted false
      cohort Time.now.year
    end
  end
  