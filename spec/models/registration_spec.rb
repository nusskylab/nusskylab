require 'rails_helper'

RSpec.describe Registration, type: :model do
  it '#get_response_for_question' do
    user = FactoryGirl.create(:user, email: '1@registration.model.spec', uid: '1.registration.model.spec')
    survey_template = FactoryGirl.create(:survey_template)
    registration = FactoryGirl.create(:registration, user: user, survey_template: survey_template)
    expect(registration.get_response_for_question(1)).to be_nil
    registration.response_content = {'1': 'test'}
    expect(registration.get_response_for_question(1)).to eql 'test'
  end
end
