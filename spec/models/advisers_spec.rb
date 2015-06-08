require 'rails_helper'

describe Adviser do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:adviser, user: nil)).not_to be_valid
  end

  it 'is invalid to associate with adviser#user' do
    user = FactoryGirl.create(:user)
    expect(FactoryGirl.create(:adviser, user: user)).to be_valid
    expect(FactoryGirl.build(:adviser, user: user)).not_to be_valid
  end
end
