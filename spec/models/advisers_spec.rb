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

  it 'should have get_advisee_users method' do
    user1 = FactoryGirl.create(:user, email: 'user1@adviser.model.spec', uid: 'uid1@adviser.model.spec')
    adviser1 = FactoryGirl.create(:adviser, user: user1)
    expect(adviser1.get_advisee_users.length).to eql 0

    user2 = FactoryGirl.create(:user, email: 'user2@adviser.model.spec', uid: 'uid2@adviser.model.spec')
    adviser2 = FactoryGirl.create(:adviser, user: user2)
    team1 = FactoryGirl.create(:team, team_name: '1.adviser.model.spec', adviser: adviser2)
    team2 = FactoryGirl.create(:team, team_name: '2.adviser.model.spec', adviser: adviser2)
    student_user1 = FactoryGirl.create(:user, email: 'user3@adviser.model.spec', uid: 'uid3@adviser.model.spec')
    student_user2 = FactoryGirl.create(:user, email: 'user4@adviser.model.spec', uid: 'uid4@adviser.model.spec')
    student_user3 = FactoryGirl.create(:user, email: 'user5@adviser.model.spec', uid: 'uid5@adviser.model.spec')
    FactoryGirl.create(:student, user: student_user1, team: team1)
    FactoryGirl.create(:student, user: student_user2, team: team1)
    FactoryGirl.create(:student, user: student_user3, team: team2)
    advisee_users = adviser2.get_advisee_users
    expect(advisee_users.length).to eql 3
    expect(advisee_users).to include student_user1
    expect(advisee_users).to include student_user2
    expect(advisee_users).to include student_user3
  end
end
