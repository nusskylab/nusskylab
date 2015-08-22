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

  it 'should have admin? class method' do
    user1 = FactoryGirl.create(:user, email: 'user1@admin.model.spec', uid: 'uid1@admin.model.spec')
    user2 = FactoryGirl.create(:user, email: 'user2@admin.model.spec', uid: 'uid2@admin.model.spec')
    FactoryGirl.create(:admin, user: user1)
    expect(Admin.admin?(user1.id)).not_to be_nil
    expect(Admin.admin?(user2.id)).to be_nil
  end
end
