require 'rails_helper'

describe Mentor do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:mentor, user: nil)).not_to be_valid
  end

  it 'is invalid to associate with mentor#user' do
    user = FactoryGirl.create(:user)
    expect(FactoryGirl.create(:mentor, user: user)).to be_valid
    expect(FactoryGirl.build(:mentor, user: user)).not_to be_valid
  end
end
