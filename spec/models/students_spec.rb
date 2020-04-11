require 'rails_helper'

RSpec.describe Student, type: :model do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:student, user: nil, team: nil)).not_to be_valid
  end

  it 'is invalid to associate with student#user' do
    user = FactoryGirl.create(:user)
    expect(FactoryGirl.create(:student, user: user, team: nil)).to be_valid
    expect(FactoryGirl.build(:student, user: user, team: nil)).not_to be_valid
  end

  it '.to_csv' do
    adviser_user = FactoryGirl.create(:user, email: 'user1@student.model.spec', uid: 'uid1.student.model.spec')
    mentor_user = FactoryGirl.create(:user, email: 'user2@student.model.spec', uid: 'uid2.student.model.spec')
    adviser = FactoryGirl.create(:adviser, user: adviser_user)
    mentor = FactoryGirl.create(:mentor, user: mentor_user)
    team1 = FactoryGirl.create(:team, team_name: '1.student.model.spec', adviser: adviser, mentor: mentor)
    student1_user = FactoryGirl.create(:user, email: 'user3@student.model.spec', uid: 'uid3.student.model.spec')
    student2_user = FactoryGirl.create(:user, email: 'user4@student.model.spec', uid: 'uid4.student.model.spec')
    FactoryGirl.create(:student, user: student1_user, team: team1)
    FactoryGirl.create(:student, user: student2_user, team: team1)
    require 'csv'
    csv = CSV.parse(Student.to_csv)
    expect(csv.first).to eql ['User Name', 'User Email', 'Team Name', 'Project Level', 'Adviser Name', 'Has Dropped', 'Registered on']
  end

  it '.student?' do
    user1 = FactoryGirl.create(:user, email: 'user1@student.model.spec',
                               uid: 'https://openid.nus.edu.sg/student1')
    user2 = FactoryGirl.create(:user, email: 'user2@student.model.spec',
                               uid: 'https://openid.nus.edu.sg/student2')
    user3 = FactoryGirl.create(:user, email: 'user3@student.model.spec',
                               uid: 'https://openid.nus.edu.sg/student3')
    expect(FactoryGirl.create(:student, user: user1, team: nil)).to be_valid
    expect(FactoryGirl.create(:student, user: user2, team: nil)).to be_valid
    expect(Student.student?(user1.id)).not_to be nil
    expect(Student.student?(user2.id)).not_to be nil
    expect(Student.student?(user3.id)).to be  nil
  end

  it '#get_teammates' do
    adviser_user = FactoryGirl.create(:user, email: 'user0@student.model.spec', uid: 'uid0.student.model.spec')
    adviser = FactoryGirl.create(:adviser, user: adviser_user)
    team = FactoryGirl.create(:team, adviser: adviser, mentor: nil)
    user1 = FactoryGirl.create(:user, email: 'user1@student.model.spec', uid: 'uid1.student.model.spec')
    user2 = FactoryGirl.create(:user, email: 'user2@student.model.spec', uid: 'uid2.student.model.spec')
    user3 = FactoryGirl.create(:user, email: 'user3@student.model.spec', uid: 'uid3.student.model.spec')
    student1 = FactoryGirl.create(:student, user: user1, team: team)
    student2 = FactoryGirl.create(:student, user: user2, team: team)
    student3 = FactoryGirl.create(:student, user: user3, team: nil)
    teammates = student1.get_teammates()
    expect(teammates.length).to eq 1
    expect(teammates).to include student2
    expect(teammates).not_to include student1
    expect(teammates).not_to include student3
    teammates = student3.get_teammates()
    expect(teammates.length).to eq 0
  end

  it '#adviser' do
    user1 = FactoryGirl.create(:user, email: 'user1@student.model.spec', uid: 'uid1.student.model.spec')
    student = FactoryGirl.build(:student, user: user1, team: nil)
    expect(student.adviser).to be_nil
    team = FactoryGirl.build(:team, adviser: nil, mentor: nil)
    student = FactoryGirl.build(:student, user: user1, team: team)
    expect(student.adviser).to be_nil
    adviser_user = FactoryGirl.create(:user, email: 'user0@student.model.spec', uid: 'uid0.student.model.spec')
    adviser = FactoryGirl.create(:adviser, user: adviser_user)
    team = FactoryGirl.create(:team, adviser: adviser, mentor: nil)
    student = FactoryGirl.build(:student, user: user1, team: team)
    expect(student.adviser).to eql adviser
  end
end
