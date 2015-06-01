require 'rails_helper'

describe Student do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:student, user: nil)).not_to be_valid
  end

  it 'is invalid to associate with student#user' do
    user = FactoryGirl.create(:user)
    expect(FactoryGirl.create(:student, user: user)).to be_valid
    expect(FactoryGirl.build(:student, user: user)).not_to be_valid
  end

  it 'should have student? method' do
    user1 = FactoryGirl.create(:user)
    user2 = FactoryGirl.create(:user, email: 'test4@example.com',
                               uid: 'https://openid.nus.edu.sg/a0000002')
    user3 = FactoryGirl.create(:user, email: 'test5@example.com',
                               uid: 'https://openid.nus.edu.sg/a0000003')
    expect(FactoryGirl.create(:student, user: user1)).to be_valid
    expect(FactoryGirl.create(:student, user: user2)).to be_valid
    expect(Student.student?(user1.id)).to be true
    expect(Student.student?(user2.id)).to be true
    expect(Student.student?(user3.id)).to be  false
  end
end
