require 'rails_helper'

describe Team do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:team, team_name: nil)).not_to be_valid
  end

  it 'should have clean_project_level method' do
    team1 = FactoryGirl.build(:team, project_level: 'Gemini')
    expect(team1).to be_valid
    expect(team1.project_level).to eq('Gemini')
    team1 = FactoryGirl.build(:team, project_level: 'Vostok')
    expect(team1).to be_valid
    expect(team1.project_level).to eq('Vostok')
    team1 = FactoryGirl.build(:team, project_level: 'Apollo 11')
    expect(team1).to be_valid
    expect(team1.project_level).to eq('Apollo 11')

    team2 = FactoryGirl.build(:team, project_level: nil)
    expect(team2).to be_valid
    expect(team2.project_level).to eq('Vostok')
    team3 = FactoryGirl.build(:team, project_level: 'Project Gemini')
    expect(team3).to be_valid
    expect(team3.project_level).to eq('Vostok')
    team4 = FactoryGirl.build(:team, project_level: 'Random string')
    expect(team4).to be_valid
    expect(team4.project_level).to eq('Vostok')
  end

  it 'should have get_relevant_users method' do
    user1 = FactoryGirl.create(:user, email: 'user1@team.model.spec', uid: 'uid1@team.model.spec')
    user_not_related = FactoryGirl.create(:user, email: 'user2@team.model.spec', uid: 'uid2@team.model.spec')
    user_teammate = FactoryGirl.create(:user, email: 'user3@team.model.spec', uid: 'uid3@team.model.spec')
    user_evaluated = FactoryGirl.create(:user, email: 'user4@team.model.spec', uid: 'uid4@team.model.spec')
    user_evaluator = FactoryGirl.create(:user, email: 'user5@team.model.spec', uid: 'uid5@team.model.spec')
    user_adviser = FactoryGirl.create(:user, email: 'user6@team.model.spec', uid: 'uid6@team.model.spec')
    user_mentor = FactoryGirl.create(:user, email: 'user7@team.model.spec', uid: 'uid7@team.model.spec')
    adviser = FactoryGirl.create(:adviser, user: user_adviser)
    mentor = FactoryGirl.create(:mentor, user: user_mentor)
    team1 = FactoryGirl.create(:team, team_name: 'team_1.team.model.spec', adviser: adviser, mentor: mentor)
    team_evaluated = FactoryGirl.create(:team, team_name: 'team_2.team.model.spec', adviser: adviser)
    team_evaluator = FactoryGirl.create(:team, team_name: 'team_3.team.model.spec', adviser: adviser)
    FactoryGirl.create(:evaluating, evaluated: team_evaluated, evaluator: team1)
    FactoryGirl.create(:evaluating, evaluated: team1, evaluator: team_evaluator)
    student1 = FactoryGirl.create(:student, user: user1, team: team1)
    student_non_relation = FactoryGirl.create(:student, user: user_not_related, team: nil)
    student_teammate = FactoryGirl.create(:student, user: user_teammate, team: team1)
    student_evaluated = FactoryGirl.create(:student, user: user_evaluated, team: team_evaluated)
    student_evaluator = FactoryGirl.create(:student, user: user_evaluator, team: team_evaluator)

    closely_related = team1.get_relevant_users
    expect(closely_related.length).to be 4
    expect(closely_related).to include user1
    expect(closely_related).to include user_teammate
    expect(closely_related).to include user_adviser
    expect(closely_related).to include user_mentor
    related = team1.get_relevant_users(true, false)
    expect(related.length).to be 5
    expect(related).to include user1
    expect(related).to include user_teammate
    expect(related).to include user_adviser
    expect(related).to include user_mentor
    expect(related).to include user_evaluator
    related = team1.get_relevant_users(false, true)
    expect(related.length).to be 5
    expect(related).to include user1
    expect(related).to include user_teammate
    expect(related).to include user_adviser
    expect(related).to include user_mentor
    expect(related).to include user_evaluated
  end

  it 'should have get_own_submissions_as_hash method' do

  end
end
