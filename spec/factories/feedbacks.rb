FactoryGirl.define do
  factory :feedback do
    team nil
    evaluating nil
    target_team_id nil
    adviser_id nil
    target_type 0
    survey_template nil
    response_content '{1: 0}'
  end

end
