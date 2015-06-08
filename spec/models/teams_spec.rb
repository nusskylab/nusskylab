require 'rails_helper'

describe Team do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:team, team_name: nil, adviser: nil, mentor: nil)).not_to be_valid
  end

  it 'should set project_level to be one of 3 values' do
    team1 = FactoryGirl.build(:team, project_level: nil, adviser: nil, mentor: nil)
    expect(team1).to be_valid
    expect(team1.project_level).to eq('Vostok')
    team2 = FactoryGirl.build(:team, project_level: 'Gemini', adviser: nil, mentor: nil)
    expect(team2).to be_valid
    expect(team2.project_level).to eq('Gemini')
    team3 = FactoryGirl.build(:team, project_level: 'Project Gemini', adviser: nil, mentor: nil)
    expect(team3).to be_valid
    expect(team3.project_level).to eq('Vostok')
  end
end
