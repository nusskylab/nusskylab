require 'rails_helper'

RSpec.describe MentorMatchings, type: :model do
    it 'is invalid with choices missing' do
        expect(FactoryGirl.build(:mentor_matchings, choice_ranking: nil)).not_to be_valid
    end

    it 'is invalid as team choice have already been selected' do
        #for student
        user1 = FactoryGirl.create(:user, email: 'test2@gmail.com', uid: 'https://openid.nus.edu.sg/a0000002')
        user2 = FactoryGirl.create(:user, email: 'test3@gmail.com', uid: 'https://openid.nus.edu.sg/a0000003')
        user3 = FactoryGirl.create(:user, email: 'test4@gmail.com', uid: 'https://openid.nus.edu.sg/a0000004')
        user4 = FactoryGirl.create(:user, email: 'test5@gmail.com', uid: 'https://openid.nus.edu.sg/a0000005')
        #for mentors
        user5 = FactoryGirl.create(:user, email: 'test6@gmail.com', uid: 'https://openid.nus.edu.sg/a0000006')
        user6 = FactoryGirl.create(:user, email: 'test7@gmail.com', uid: 'https://openid.nus.edu.sg/a0000007')
        user7 = FactoryGirl.create(:user, email: 'test8@gmail.com', uid: 'https://openid.nus.edu.sg/a0000008')
        user8 = FactoryGirl.create(:user, email: 'test9@gmail.com', uid: 'https://openid.nus.edu.sg/a0000009')
        team1 = FactoryGirl.create(:team, team_name: '1.team.model.spec')
        team2 = FactoryGirl.create(:team, team_name: '2.team.model.spec')
        mentor1 = FactoryGirl.create(:mentor, user: user5)
        mentor2 = FactoryGirl.create(:mentor, user: user6)
        mentor3 = FactoryGirl.create(:mentor, user: user7)
        mentor4 = FactoryGirl.create(:mentor, user: user8)
        student1 = FactoryGirl.create(:student, user: user1, team: team1)
        student2 = FactoryGirl.create(:student, user: user2, team: team1)
        student3 = FactoryGirl.create(:student, user: user3, team: team2)
        student4 = FactoryGirl.create(:student, user: user4, team: team2)
        
        FactoryGirl.create(:mentor_matchings, team: team1, mentor: mentor1, choice_ranking: 1)
        FactoryGirl.create(:mentor_matchings, team: team1, mentor: mentor2, choice_ranking: 2)
        FactoryGirl.create(:mentor_matchings, team: team1, mentor: mentor3, choice_ranking: 3)
        
        expect(FactoryGirl.build(:mentor_matchings, team: team1, mentor: mentor4, choice_ranking: 1)).not_to be_valid
        expect(FactoryGirl.build(:mentor_matchings, team: team1, mentor: mentor4, choice_ranking: 2)).not_to be_valid
        expect(FactoryGirl.build(:mentor_matchings, team: team1, mentor: mentor4, choice_ranking: 3)).not_to be_valid
    end
end