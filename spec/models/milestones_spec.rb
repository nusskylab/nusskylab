require 'rails_helper'

RSpec.describe Milestone, type: :model do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:milestone, name: nil)).not_to be_valid
    expect(FactoryGirl.build(:milestone, submission_deadline: nil)).not_to be_valid
    expect(FactoryGirl.build(:milestone, peer_evaluation_deadline: nil)).not_to be_valid
  end

  it 'is invalid with name taken by another milestone' do
    expect(FactoryGirl.create(:milestone)).to be_valid
    expect(FactoryGirl.build(:milestone)).not_to be_valid
  end

  it 'should have get_prev_milestone method' do
    milestone1 = FactoryGirl.create(:milestone, name: 'milestone_1.milestone.model.spec')
    milestone2 = FactoryGirl.create(:milestone, name: 'milestone_2.milestone.model.spec')
    milestone3 = FactoryGirl.create(:milestone, name: 'milestone_3.milestone.model.spec')
    expect(milestone1.get_prev_milestone).to be_nil
    expect(milestone2.get_prev_milestone.id).to eq milestone1.id
    expect(milestone3.get_prev_milestone.id).to eq milestone2.id
  end

  # a temporary test for a temporary method, will be kept temporarily
  it 'should have get_overall_rating_question_id method' do
    milestone1 = FactoryGirl.create(:milestone, name: 'Milestone 1')
    milestone2 = FactoryGirl.create(:milestone, name: 'Milestone 2')
    milestone3 = FactoryGirl.create(:milestone, name: 'Milestone 3')
    milestone4 = FactoryGirl.build(:milestone, name: 'Nothing')
    expect(milestone1.get_overall_rating_question_id).to eq 'q[5][1]'
    expect(milestone2.get_overall_rating_question_id).to eq 'q[6][1]'
    expect(milestone3.get_overall_rating_question_id).to eq 'q[6][1]'
    expect(milestone4.get_overall_rating_question_id).to eq 'NON_EXISTENT'
  end
end
