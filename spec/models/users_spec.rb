require 'rails_helper'

describe User do
  it 'is invalid with required params missing' do
    expect(FactoryGirl.build(:user, email: nil)).not_to be_valid
    expect(FactoryGirl.build(:user, user_name: nil)).not_to be_valid
    expect(FactoryGirl.build(:user, uid: nil)).not_to be_valid
  end

  it 'is invalid with duplicated email' do
    expect(FactoryGirl.create(:user)).to be_valid
    expect(FactoryGirl.build(:user, uid: 'https://openid.nus.edu.sg/a0000002')).not_to be_valid
  end

  it 'is invalid with duplicated uid from one provider' do
    expect(FactoryGirl.create(:user)).to be_valid
    expect(FactoryGirl.build(:user, email: 'test1@gmail.com')).not_to be_valid
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
    expect(user.uid).to eq('https://openid.nus.edu.sg/a0000001')
  end

  it 'should only allow NUS as provider currently' do
    expect(FactoryGirl.build(:user, provider: 'facebook')).not_to be_valid
    expect(FactoryGirl.build(:user, provider: 'github')).not_to be_valid
  end
end
