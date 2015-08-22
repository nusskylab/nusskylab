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

  it 'should have adviser? class method' do
    user1 = FactoryGirl.create(:user, email: 'user1@adviser.model.spec', uid: 'uid1@adviser.model.spec')
    user2 = FactoryGirl.create(:user, email: 'user2@adviser.model.spec', uid: 'uid2@adviser.model.spec')
    FactoryGirl.create(:adviser, user: user1)
    expect(Adviser.adviser?(user1.id)).not_to be_nil
    expect(Adviser.adviser?(user2.id)).to be_nil
  end
end
