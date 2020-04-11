require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is invalid with required params missing' do
    expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
    expect(FactoryGirl.build(:user, user_name: nil)).not_to be_valid
  end

  it 'is invalid with duplicated email' do
    expect(FactoryGirl.create(:user)).to be_valid
    expect(FactoryGirl.build(:user, uid: 'https://openid.nus.edu.sg/a0000002')).not_to be_valid
  end

  it 'is invalid with duplicated uid from one provider' do
    expect(FactoryGirl.create(:user, email: 'user1@user.model.spec', provider: 1)).to be_valid
    expect(FactoryGirl.build(:user, email: 'user1@user.model.spec', provider: 1)).not_to be_valid
  end

  it 'is invalid with wrong email format' do
    expect(FactoryGirl.build(:user, email: 'test1@gmail')).not_to be_valid
    expect(FactoryGirl.build(:user, email: 'test1@.com')).not_to be_valid
    expect(FactoryGirl.build(:user, email: '@gmail.com')).not_to be_valid
    expect(FactoryGirl.build(:user, email: 'test1')).not_to be_valid
  end

  it 'should auto downcase its uid' do
    user = FactoryGirl.build(:user, uid: 'https://openid.nus.edu.sg/A0000001')
    expect(user).to be_valid
    expect(user.uid).to eq 'https://openid.nus.edu.sg/a0000001'
  end

  it '.from_omniauth' do
    auth_info = {email: 'user1@user.model.spec', name: 'user 1'}
    auth_info.define_singleton_method(:email) do
      return self[:email]
    end
    auth_info.define_singleton_method(:name) do
      return self[:name]
    end
    auth = {provider: 'NUS', uid: 'https://openid.nus.edu.sg/uid1.user.model.spec', info: auth_info}
    auth.define_singleton_method(:provider) do
      return self[:provider]
    end
    auth.define_singleton_method(:uid) do
      return self[:uid]
    end
    auth.define_singleton_method(:info) do
      return self[:info]
    end
    user_auth = User.from_omniauth(auth)
    expect(user_auth).not_to be_nil
    testing_user_name = 'testing'
    user_auth.user_name = testing_user_name
    user_auth.save
    user1 = FactoryGirl.build(:user, email: 'user1@user.model.spec', uid: 'uid1@user.model.spec')
    expect(user1).not_to be_valid
    expect(user1.provider_NUS?).to be true
    user_auth2 = User.from_omniauth(auth)
    expect(user_auth2).not_to be_nil
    expect(user_auth2.user_name).to eql testing_user_name
  end

  it '#clean_user_provider' do
    user = FactoryGirl.build(:user, email: 'user1@user.model.spec', uid: 'uid1.user.mode.spec',
                             provider: nil)
    user.clean_user_provider('facebook')
    expect(user.provider_nil?).to be true
    user.clean_user_provider('NUS')
    expect(user.provider_NUS?).to be true
  end
end
