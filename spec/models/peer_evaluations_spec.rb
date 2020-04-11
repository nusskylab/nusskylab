require 'rails_helper'

RSpec.describe PeerEvaluation, type: :model do
  it 'is invalid with required field missing' do
    milestone = FactoryGirl.create(:milestone, name: 'PeerEvaluation milestone 1')
    team1 = FactoryGirl.create(:team, team_name: 'PeerEvaluation team 1', adviser: nil, mentor: nil)
    team2 = FactoryGirl.create(:team, team_name: 'PeerEvaluation team 2', adviser: nil, mentor: nil)
    submission = FactoryGirl.create(:submission, milestone: milestone, team: team1)
    adviser = FactoryGirl.create(:adviser,
                                 user: FactoryGirl.create(:user, email: 'adviser1@peerEval.com',
                                                          uid: 'adviser1.peer_eval'))
    expect(FactoryGirl.build(:peer_evaluation, team: nil, submission: submission, adviser: nil)).not_to be_valid
    expect(FactoryGirl.build(:peer_evaluation, team: team2, submission: nil, adviser: nil)).not_to be_valid
    expect(FactoryGirl.build(:peer_evaluation, team: nil, submission: nil, adviser: adviser)).not_to be_valid
  end

  it 'is invalid with combination of team_id and submission_id taken' do
    milestone = FactoryGirl.create(:milestone, name: 'PeerEvaluation milestone 1')
    team1 = FactoryGirl.create(:team, team_name: 'PeerEvaluation team 1', adviser: nil, mentor: nil)
    team2 = FactoryGirl.create(:team, team_name: 'PeerEvaluation team 2', adviser: nil, mentor: nil)
    submission = FactoryGirl.create(:submission, milestone: milestone, team: team1)
    expect(FactoryGirl.create(:peer_evaluation, team: team2, submission: submission, adviser: nil)).to be_valid
    expect(FactoryGirl.build(:peer_evaluation, team: team2, submission: submission, adviser: nil)).not_to be_valid
  end

  it 'is invalid with combination of adviser_id and submission_id taken' do
    milestone = FactoryGirl.create(:milestone, name: 'PeerEvaluation milestone 1')
    team1 = FactoryGirl.create(:team, team_name: 'PeerEvaluation team 1', adviser: nil, mentor: nil)
    submission = FactoryGirl.create(:submission, milestone: milestone, team: team1)
    adviser = FactoryGirl.create(:adviser,
                                 user: FactoryGirl.create(:user, email: 'adviser1@peerEval.com',
                                                          uid: 'adviser1.peer_eval'))
    expect(FactoryGirl.create(:peer_evaluation, team: nil, submission: submission, adviser: adviser)).to be_valid
    expect(FactoryGirl.build(:peer_evaluation, team: nil, submission: submission, adviser: adviser)).not_to be_valid
  end

  it '#submitted_late?' do
    milestone1 = FactoryGirl.create(:milestone, name: 'Submission milestone 1', peer_evaluation_deadline: Time.now - 1.days)
    milestone2 = FactoryGirl.create(:milestone, name: 'Submission milestone 2', peer_evaluation_deadline: Time.now + 10.days)
    team1 = FactoryGirl.create(:team, team_name: '1.peer_evaluation.model.spec')
    team2 = FactoryGirl.create(:team, team_name: '2.peer_evaluation.model.spec')
    submission1 = FactoryGirl.create(:submission, milestone: milestone1, team: team1)
    submission2 = FactoryGirl.create(:submission, milestone: milestone2, team: team1)
    peer_evaluation1 = FactoryGirl.create(:peer_evaluation, team: team2, submission: submission1)
    peer_evaluation2 = FactoryGirl.create(:peer_evaluation, team: team2, submission: submission2)
    expect(peer_evaluation1.submitted_late?).to be true
    expect(peer_evaluation2.submitted_late?).to be false
  end
end
