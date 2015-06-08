require 'rails_helper'

describe Submission do
  it 'is invalid with required field missing' do
    milestone = FactoryGirl.create(:milestone, name: 'Submission milestone 1')
    team = FactoryGirl.create(:team, team_name: 'Submission team 1', adviser: nil, mentor: nil)
    expect(FactoryGirl.build(:submission, team: nil, milestone: milestone)).not_to be_valid
    expect(FactoryGirl.build(:submission, milestone: nil, team: team)).not_to be_valid
    expect(FactoryGirl.build(:submission, project_log: nil, milestone: milestone, team: team)).not_to be_valid
    expect(FactoryGirl.build(:submission, read_me: nil, milestone: milestone, team: team)).not_to be_valid
    expect(FactoryGirl.build(:submission, video_link: nil, milestone: milestone, team: team)).not_to be_valid
  end

  it 'is invalid with combination of team_id and milestone_id taken' do
    milestone = FactoryGirl.create(:milestone, name: 'Submission milestone 1')
    team = FactoryGirl.create(:team, team_name: 'Submission team 1', adviser: nil, mentor: nil)
    expect(FactoryGirl.create(:submission, milestone: milestone, team: team)).to be_valid
    expect(FactoryGirl.build(:submission, milestone: milestone, team: team)).not_to be_valid
  end
end
