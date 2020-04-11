require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it '#omniauth_authorize_path' do
    expect(helper.omniauth_authorize_path('open_id')).to eql 'https://openid.nus.edu.sg/auth'
  end

  it '#get_question_name' do
    survey_template1 = FactoryGirl.create(:survey_template, survey_type: 2)
    question = FactoryGirl.create(:question, survey_template: survey_template1)
    expect(helper.get_question_name(question)).to eql "questions[#{question.id}]"
  end

  it '#get_current_cohort' do
    expect(helper.get_current_cohort).to eql Time.now.year
  end
end
