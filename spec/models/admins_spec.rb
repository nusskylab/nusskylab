require 'rails_helper'

describe Adviser do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:admin, user: nil)).not_to be_valid
  end

  it 'is invalid to associate with admin#user' do
    user = FactoryGirl.create(:user)
    expect(FactoryGirl.create(:admin, user: user)).to be_valid
    expect(FactoryGirl.build(:admin, user: user)).not_to be_valid
  end
end
