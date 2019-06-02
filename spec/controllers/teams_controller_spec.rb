require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  describe 'GET #index' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render index for adviser users' do
        adviser1 = FactoryGirl.create(:adviser, user_id: subject.current_user.id)
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        user2 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        team1 = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        team2 = FactoryGirl.create(:team, adviser: adviser1, team_name: '2.team.controller.spec')
        student1 = FactoryGirl.create(:student, user: user1, team: team1)
        student2 = FactoryGirl.create(:student, user: user2, team: team2)
        get :index
        expect(response).to render_template(:index)
        expect(assigns(:teams).length).to eql Team.all.length
      end

      it 'should redirect to home_path for non_admin and non_adviser' do
        get :index
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should assign @teams' do
        user0 = FactoryGirl.create(:user, email: '0@team.controller.spec', uid: '0.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user0.id)
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        user2 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        team1 = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        team2 = FactoryGirl.create(:team, adviser: adviser1, team_name: '2.team.controller.spec')
        get :index
        expect(assigns(:teams).length).to eql Team.all.length
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #new' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        get :new
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render new for admin user' do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        post :create
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        post :create
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect to students with success for admin user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        post :create, team: {team_name: '1.team.controller.spec',
                             project_level: 'Project Gemini', adviser_id: adviser1.id}
        expect(response).to redirect_to(teams_path(cohort: controller.current_cohort))
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to admins with danger for admin user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team1 = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        post :create, team: {team_name: '1.team.controller.spec',
                             project_level: 'Project Gemini', adviser_id: adviser1.id}
        expect(response).to redirect_to(new_team_path(cohort: controller.current_cohort))
        expect(flash[:danger]).not_to be_nil
      end
    end
  end

  describe 'GET #show' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        get :show, id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render show for current student' do
        # TODO: check more on the locals of student show page
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user_id: subject.current_user.id, team: team)
        get :show, id: team.id
        expect(response).to render_template(:show)
      end

      it 'should redirect to home_path for non_admin and non_current_user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        get :show, id: team.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render show for admin user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        get :show, id: team.id
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #edit' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        get :edit, id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render edit for current student' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user_id: subject.current_user.id, team: team)
        get :edit, id: team.id
        expect(response).to render_template(:edit)
      end

      it 'should redirect to home_path for non_admin and non_current_user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        get :edit, id: team.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render edit for admin user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        get :edit, id: team.id
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PUT #update' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        put :update, id: team.id, team: {team_name: '2.team.controller.spec'}
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should update for current student' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user_id: subject.current_user.id, team: team)
        put :update, id: team.id, team: {team_name: '2.team.controller.spec'}
        expect(response).to redirect_to(team_path(team))
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to home_path for non_admin and non_current_user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        put :update, id: team.id, team: {team_name: '2.team.controller.spec'}
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should update for admin user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        put :update, id: team.id, team: {team_name: '2.team.controller.spec'}
        expect(response).to redirect_to(team_path(team))
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        delete :destroy, id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        delete :destroy, id: team.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect with success for admin user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        delete :destroy, id: team.id
        expect(response).to redirect_to(teams_path(cohort: controller.current_cohort))
        expect(flash[:success]).not_to be_nil
      end
    end
  end

  describe 'GET #match_mentor' do
    context 'user not logged in' do
      it 'should redirect to root path' do
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        get :match_mentor, id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      it 'should render the match mentor form for current student' do
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        get :match_mentor, id: team.id
        expect(response).to render_template(:match_mentor)
      end
    end

    context 'user logged in and admin' do
      it 'should render the match mentor form for current student' do
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        get :match_mentor, id: team.id
        expect(response).to render_template(:match_mentor)
      end
    end
  end
end
