require 'rails_helper'

RSpec.describe Submission, type: :model do
  it 'is invalid with required field missing' do
    milestone = FactoryGirl.create(:milestone, name: 'Submission milestone 1')
    team = FactoryGirl.create(:team, team_name: '1.submission.model.spec', adviser: nil, mentor: nil)
    expect(FactoryGirl.build(:submission, team: nil, milestone: milestone)).not_to be_valid
    expect(FactoryGirl.build(:submission, milestone: nil, team: team)).not_to be_valid
    expect(FactoryGirl.build(:submission, project_log: nil, milestone: milestone, team: team)).not_to be_valid
    expect(FactoryGirl.build(:submission, read_me: nil, milestone: milestone, team: team)).not_to be_valid
    expect(FactoryGirl.build(:submission, video_link: nil, milestone: milestone, team: team)).not_to be_valid
  end

  it 'is invalid with combination of team_id and milestone_id taken' do
    milestone = FactoryGirl.create(:milestone, name: 'Submission milestone 1')
    team = FactoryGirl.create(:team, team_name: '1.submission.model.spec', adviser: nil, mentor: nil)
    expect(FactoryGirl.create(:submission, milestone: milestone, team: team)).to be_valid
    expect(FactoryGirl.build(:submission, milestone: milestone, team: team)).not_to be_valid
  end

  it '#submitted_late?' do
    milestone1 = FactoryGirl.create(:milestone, name: 'Submission milestone 1', submission_deadline: Time.now - 1.days)
    milestone2 = FactoryGirl.create(:milestone, name: 'Submission milestone 2', submission_deadline: Time.now + 10.days)
    team = FactoryGirl.create(:team, team_name: '1.submission.model.spec')
    submission1 = FactoryGirl.create(:submission, milestone: milestone1, team: team)
    submission2 = FactoryGirl.create(:submission, milestone: milestone2, team: team)
    expect(submission1.submitted_late?).to be true
    expect(submission2.submitted_late?).to be false
  end
end
