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

  it 'should have mentor? class method' do
    user1 = FactoryGirl.create(:user, email: 'user1@mentor.model.spec', uid: 'uid1@mentor.model.spec')
    user2 = FactoryGirl.create(:user, email: 'user2@mentor.model.spec', uid: 'uid2@mentor.model.spec')
    FactoryGirl.create(:mentor, user: user1)
    expect(Mentor.mentor?(user1.id)).not_to be_nil
    expect(Mentor.mentor?(user2.id)).to be_nil
  end
end
