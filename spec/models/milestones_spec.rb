require 'rails_helper'

describe Milestone do
  it 'is invalid with required field missing' do
    expect(FactoryGirl.build(:milestone, name: nil)).not_to be_valid
    expect(FactoryGirl.build(:milestone, deadline: nil)).not_to be_valid
  end

  it 'is invalid with name taken by another milestone' do
    expect(FactoryGirl.create(:milestone)).to be_valid
    expect(FactoryGirl.build(:milestone)).not_to be_valid
  end
end
