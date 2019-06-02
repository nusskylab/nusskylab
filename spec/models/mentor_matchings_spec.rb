require 'rails_helper'

RSpec.describe MentorMatchings, type: :model do
    it 'is invalid with choices missing' do
        expect(FactoryGirl.build(:mentor_matchings, choice_ranking: nil)).not_to be_valid
    end

    it 'is invalid with team choice have already been selected' do
        expect(FactoryGirl.build(:mentor_matchings, choice_ranking: 1)).to be_valid
        expect(FactoryGirl.build(:mentor_matchings, choice_ranking: 1)).not_to be_valid
    end
end