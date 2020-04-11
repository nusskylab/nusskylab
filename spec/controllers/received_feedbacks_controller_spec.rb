require 'rails_helper'

RSpec.describe ReceivedFeedbacksController, type: :controller do
  describe 'GET #index' do
    context 'user not logged in' do
      it 'should return 404 when required entities not found' do
        get :index, milestone_id: 1, team_id: 1
        expect(response.status).to eql 404
      end

      it 'should redirect to root_path for non_user' do
        milestone = FactoryGirl.create(:milestone, name: 'Milestone 1')
        team = FactoryGirl.create(:team, team_name: 'Team 1')
        get :index, milestone_id: milestone.id, team_id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should handle different cases' do
        milestone = FactoryGirl.create(:milestone, name: 'Milestone 1')
        team = FactoryGirl.create(:team, team_name: 'Team 1')
        get :index, milestone_id: milestone.id, team_id: team.id
        expect(response).to redirect_to(controller.home_path)

        FactoryGirl.create(:student, user: controller.current_user, team: team)
        get :index, milestone_id: milestone.id, team_id: team.id
        expect(response).to render_template(:index)
      end
    end
  end
end
