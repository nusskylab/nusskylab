require 'rails_helper'

RSpec.describe Question, type: :model do
  it 'is invalid with invalid json for content or extras' do
    expect(FactoryGirl.build(:question, content: '[invalid json')).not_to be_valid
    expect(FactoryGirl.build(:question, extras: '[invalid json')).not_to be_valid
  end
end
