require 'rails_helper'

describe Evaluating do
  it 'is invalid with required field missing' do
    team1 = FactoryGirl.create(:team, team_name: 'Evaluating team 1', adviser: nil, mentor: nil)
    expect(FactoryGirl.build(:evaluating, evaluator: team1, evaluated: nil)).not_to be_valid
    expect(FactoryGirl.build(:evaluating, evaluator: nil, evaluated: team1)).not_to be_valid
  end

  it 'is invalid with combination of evaluator_id and evaluated_id taken' do
    team1 = FactoryGirl.create(:team, team_name: 'Evaluating team 1', adviser: nil, mentor: nil)
    team2 = FactoryGirl.create(:team, team_name: 'Evaluating team 2', adviser: nil, mentor: nil)
    expect(FactoryGirl.create(:evaluating, evaluator: team1, evaluated: team2)).to be_valid
    expect(FactoryGirl.build(:evaluating, evaluator: team1, evaluated: team2)).not_to be_valid
  end
end
