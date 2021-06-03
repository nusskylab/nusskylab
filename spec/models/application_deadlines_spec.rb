require 'rails_helper'

RSpec.describe ApplicationDeadline, type: :model do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:application_deadline, name: nil)).not_to be_valid
    expect(FactoryGirl.build(:application_deadline, submission_deadline: nil)).not_to be_valid
  end
end
