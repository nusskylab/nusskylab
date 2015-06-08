FactoryGirl.define do
  factory :team, aliases: [:evaluator, :evaluated] do
    team_name 'test_team_1'
    project_level 'Gemini'
    adviser
    mentor
  end
end
