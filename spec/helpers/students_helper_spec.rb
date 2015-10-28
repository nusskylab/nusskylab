require 'rails_helper'

RSpec.describe StudentsHelper, type: :helper do
  # describe '#can_current_user_create_new_student' do
  #   context 'user not logged in' do
  #     it 'should return false' do
  #       expect(helper.can_current_user_create_new_student).to be false
  #     end
  #   end

  #   context 'user logged in but not admin' do
  #     login_user
  #     it 'should return false' do
  #       expect(helper.can_current_user_create_new_student).to be false
  #     end
  #   end

  #   context 'user logged in and admin' do
  #     login_user
  #     it 'should return true' do
  #       expect(helper.can_current_user_create_new_student).to be true
  #     end
  #   end
  # end

  it '#get_student_team_name' do
    user1 = FactoryGirl.create(:user, email: '1@student.helper.spec', uid: '1.student.helper.spec')
    adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
    user2 = FactoryGirl.create(:user, email: '2@student.helper.spec', uid: '2.student.helper.spec')
    user3 = FactoryGirl.create(:user, email: '3@student.helper.spec', uid: '3.student.helper.spec')
    team1 = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.student.helper.spec')
    student1 = FactoryGirl.create(:student, user: user2, team: team1)
    student2 = FactoryGirl.create(:student, user: user3, team: nil)
    expect(helper.get_student_team_name(student1)).to eql team1.team_name
    expect(helper.get_student_team_name(student2)).to eql 'Nil'
end

  it '#get_student_team_project_level' do
    user1 = FactoryGirl.create(:user, email: '1@student.helper.spec', uid: '1.student.helper.spec')
    adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
    user2 = FactoryGirl.create(:user, email: '2@student.helper.spec', uid: '2.student.helper.spec')
    user3 = FactoryGirl.create(:user, email: '3@student.helper.spec', uid: '3.student.helper.spec')
    team1 = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.student.helper.spec')
    student1 = FactoryGirl.create(:student, user: user2, team: team1)
    student2 = FactoryGirl.create(:student, user: user3, team: nil)
    expect(helper.get_student_team_project_level(student1)).to eql team1.get_project_level
    expect(helper.get_student_team_project_level(student2)).to eql 'Nil'
  end

  it '#get_student_team_adviser_name' do
    user1 = FactoryGirl.create(:user, email: '1@student.helper.spec', uid: '1.student.helper.spec')
    adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
    user2 = FactoryGirl.create(:user, email: '2@student.helper.spec', uid: '2.student.helper.spec')
    user3 = FactoryGirl.create(:user, email: '3@student.helper.spec', uid: '3.student.helper.spec')
    user4 = FactoryGirl.create(:user, email: '4@student.helper.spec', uid: '4.student.helper.spec')
    team1 = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.student.helper.spec')
    team2 = FactoryGirl.create(:team, adviser: nil, team_name: '2.student.helper.spec')
    student1 = FactoryGirl.create(:student, user: user2, team: team1)
    student2 = FactoryGirl.create(:student, user: user3, team: nil)
    student3 = FactoryGirl.create(:student, user: user4, team: team2)
    expect(helper.get_student_team_adviser_name(student1)).to eql user1.user_name
    expect(helper.get_student_team_adviser_name(student2)).to eql 'Nil'
    expect(helper.get_student_team_adviser_name(student3)).to eql 'Nil'
  end
end
