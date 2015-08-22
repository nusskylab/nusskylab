require 'rails_helper'

RSpec.describe Feedback, type: :model do
  it 'is invalid with required fields missing' do
    team1 = FactoryGirl.create(:team, team_name: '1.feedback.model.spec')
    survey_template1 = FactoryGirl.create(:survey_template, survey_type: 2)
    expect(FactoryGirl.build(:feedback, team: team1)).not_to be_valid
    expect(FactoryGirl.build(:feedback, survey_template: survey_template1)).not_to be_valid
  end

  it 'is invalid with duplicate team_id and target_team_id' do
    team1 = FactoryGirl.create(:team, team_name: '1.feedback.model.spec')
    team2 = FactoryGirl.create(:team, team_name: '2.feedback.model.spec')
    survey_template1 = FactoryGirl.create(:survey_template, survey_type: 2)
    FactoryGirl.create(:feedback, team: team1, target_team: team2, survey_template: survey_template1)
    expect(FactoryGirl.build(:feedback, team: team1, target_team: team2,
                             survey_template: survey_template1)).not_to be_valid
  end

  it 'is invalid with duplicate team_id and adviser_id' do
    team1 = FactoryGirl.create(:team, team_name: '1.feedback.model.spec')
    user_adviser = FactoryGirl.create(:user, email: 'user1@feedback.model.spec',
                                      uid: 'uid1.feedback.model.spec')
    adviser = FactoryGirl.create(:adviser, user: user_adviser)
    survey_template1 = FactoryGirl.create(:survey_template, survey_type: 2)
    FactoryGirl.create(:feedback, team: team1, adviser: adviser, target_type: 1,
                       survey_template: survey_template1)
    expect(FactoryGirl.build(:feedback, team: team1, adviser: adviser,
                             target_type: 1, survey_template: survey_template1)).not_to be_valid
  end

  it 'should have get_response_for_question method' do
    team1 = FactoryGirl.create(:team, team_name: '1.feedback.model.spec')
    team2 = FactoryGirl.create(:team, team_name: '2.feedback.model.spec')
    survey_template1 = FactoryGirl.create(:survey_template, survey_type: 2)
    feedback1 = FactoryGirl.create(:feedback, team: team1, target_team: team2,
                                   survey_template: survey_template1, response_content: '{"1": "0"}')
    expect(feedback1.get_response_for_question(1)).to eql '0'
    expect(feedback1.get_response_for_question(2)).to be_nil
  end
end
