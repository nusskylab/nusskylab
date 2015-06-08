require 'rails_helper'

describe Student do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:student, user: nil, team: nil)).not_to be_valid
  end

  it 'is invalid to associate with student#user' do
    user = FactoryGirl.create(:user)
    expect(FactoryGirl.create(:student, user: user, team: nil)).to be_valid
    expect(FactoryGirl.build(:student, user: user, team: nil)).not_to be_valid
  end

  it 'should have student? class method' do
    user1 = FactoryGirl.create(:user, email: 'student1@gmail.com',
                               uid: 'https://openid.nus.edu.sg/student1')
    user2 = FactoryGirl.create(:user, email: 'student2@gmail.com',
                               uid: 'https://openid.nus.edu.sg/student2')
    user3 = FactoryGirl.create(:user, email: 'student3@gmail.com',
                               uid: 'https://openid.nus.edu.sg/student3')
    expect(FactoryGirl.create(:student, user: user1, team: nil)).to be_valid
    expect(FactoryGirl.create(:student, user: user2, team: nil)).to be_valid
    expect(Student.student?(user1.id)).not_to be nil
    expect(Student.student?(user2.id)).not_to be nil
    expect(Student.student?(user3.id)).to be  nil
  end

  it 'should have get_teammates method' do
    adviser_user = FactoryGirl.create(:user, email: 'adviser@gmail.com',
                                      uid: 'https://openid.nus.edu.sg/adviser')
    adviser = FactoryGirl.create(:adviser, user: adviser_user)
    team = FactoryGirl.create(:team, adviser: adviser, mentor: nil)
    user1 = FactoryGirl.create(:user, email: 'student1@gmail.com',
                               uid: 'https://openid.nus.edu.sg/student1')
    user2 = FactoryGirl.create(:user, email: 'student2@gmail.com',
                               uid: 'https://openid.nus.edu.sg/student2')
    user3 = FactoryGirl.create(:user, email: 'student3@gmail.com',
                               uid: 'https://openid.nus.edu.sg/student3')
    student1 = FactoryGirl.create(:student, user: user1, team: team)
    student2 = FactoryGirl.create(:student, user: user2, team: team)
    student3 = FactoryGirl.create(:student, user: user3, team: nil)
    teammates = student1.get_teammates()
    expect(teammates).to include student2
    expect(teammates).not_to include student1
    expect(teammates).not_to include student3
  end
end
