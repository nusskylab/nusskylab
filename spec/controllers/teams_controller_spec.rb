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
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        get :match_mentor, id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render mentor matching page for current student' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user_id: subject.current_user.id, team: team)
        get :match_mentor, id: team.id
        expect(response).to render_template(:match_mentor)
      end

      it 'should redirect to home_path for non_admin and non_current_user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        get :match_mentor, id: team.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render the match mentor form for admin' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        get :match_mentor, id: team.id
        expect(response).to render_template(:match_mentor)
      end
    end
  end

  describe 'POST #match_mentor_success' do
    context 'user not logged in' do
      it 'should redirect to root path' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')

        #Create mentors
        user2 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        user3 = FactoryGirl.create(:user, email: '3@team.controller.spec', uid: '3.team.controller.spec')
        user4 = FactoryGirl.create(:user, email: '4@team.controller.spec', uid: '4.team.controller.spec')
        mentor1 = FactoryGirl.create(:mentor, user_id: user2.id)
        mentor2 = FactoryGirl.create(:mentor, user_id: user3.id)
        mentor3 = FactoryGirl.create(:mentor, user_id: user4.id)
        teams_params = {choice_1: mentor1.id, choice_2: mentor2.id, choice_3: mentor3.id}
        post :match_mentor_success, id: team.id, team: teams_params
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should match mentor successfully for current student' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user_id: subject.current_user.id, team: team)

        #Create mentors
        user2 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        user3 = FactoryGirl.create(:user, email: '3@team.controller.spec', uid: '3.team.controller.spec')
        user4 = FactoryGirl.create(:user, email: '4@team.controller.spec', uid: '4.team.controller.spec')
        mentor1 = FactoryGirl.create(:mentor, user_id: user2.id)
        mentor2 = FactoryGirl.create(:mentor, user_id: user3.id)
        mentor3 = FactoryGirl.create(:mentor, user_id: user4.id)
        teams_params = {choice_1: mentor1.id, choice_2: mentor2.id, choice_3: mentor3.id}
        post :match_mentor_success, id: team.id, team: teams_params
        expect(response).to redirect_to(team_path(team))
        expect(flash[:success]).not_to be_nil
      end

      it 'should not match mentor successfully for current student' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')

        #Create mentors
        user2 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        user3 = FactoryGirl.create(:user, email: '3@team.controller.spec', uid: '3.team.controller.spec')
        user4 = FactoryGirl.create(:user, email: '4@team.controller.spec', uid: '4.team.controller.spec')
        mentor1 = FactoryGirl.create(:mentor, user_id: user2.id)
        mentor2 = FactoryGirl.create(:mentor, user_id: user3.id)
        mentor3 = FactoryGirl.create(:mentor, user_id: user4.id)
        teams_params = {choice_1: mentor1.id, choice_2: mentor1.id, choice_3: mentor3.id}
        post :match_mentor_success, id: team.id, team: teams_params
        expect(flash[:danger]).not_to be_nil
      end

      it 'should redirect to home_path for non_admin and non_current_user' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')

        #Create mentors
        user2 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        user3 = FactoryGirl.create(:user, email: '3@team.controller.spec', uid: '3.team.controller.spec')
        user4 = FactoryGirl.create(:user, email: '4@team.controller.spec', uid: '4.team.controller.spec')
        mentor1 = FactoryGirl.create(:mentor, user_id: user2.id)
        mentor2 = FactoryGirl.create(:mentor, user_id: user3.id)
        mentor3 = FactoryGirl.create(:mentor, user_id: user4.id)
        teams_params = {choice_1: mentor1.id, choice_2: mentor2.id, choice_3: mentor3.id}
        post :match_mentor_success, id: team.id, team: teams_params
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should match mentor successfully for admin' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')

        #Create mentors
        user2 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        user3 = FactoryGirl.create(:user, email: '3@team.controller.spec', uid: '3.team.controller.spec')
        user4 = FactoryGirl.create(:user, email: '4@team.controller.spec', uid: '4.team.controller.spec')
        mentor1 = FactoryGirl.create(:mentor, user_id: user2.id)
        mentor2 = FactoryGirl.create(:mentor, user_id: user3.id)
        mentor3 = FactoryGirl.create(:mentor, user_id: user4.id)
        teams_params = {choice_1: mentor1.id, choice_2: mentor2.id, choice_3: mentor3.id}
        post :match_mentor_success, id: team.id, team: teams_params
        expect(response).to redirect_to(team_path(team))
        expect(flash[:success]).not_to be_nil
      end

      it 'should not match mentor successfully for admin' do
        user1 = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        adviser1 = FactoryGirl.create(:adviser, user_id: user1.id)
        team = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.team.controller.spec')

        #Create mentors
        user2 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        user3 = FactoryGirl.create(:user, email: '3@team.controller.spec', uid: '3.team.controller.spec')
        user4 = FactoryGirl.create(:user, email: '4@team.controller.spec', uid: '4.team.controller.spec')
        mentor1 = FactoryGirl.create(:mentor, user_id: user2.id)
        mentor2 = FactoryGirl.create(:mentor, user_id: user3.id)
        mentor3 = FactoryGirl.create(:mentor, user_id: user4.id)
        teams_params = {choice_1: mentor1.id, choice_2: mentor1.id, choice_3: mentor3.id}
        post :match_mentor_success, id: team.id, team: teams_params
        expect(response).to redirect_to(match_mentor_team_path())
        expect(flash[:danger]).not_to be_nil
      end
    end
  end

  describe 'POST #accept_mentor' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        post :accept_mentor, id: team.id, mentor_id: mentor.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should accept mentor for current student' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user_id: subject.current_user.id, team: team)
        team.students << student
        mentor_matching = FactoryGirl.create(:mentor_matching, team_id: team.id, mentor_id: mentor.id, mentor_accepted: true)
        post :accept_mentor, id: team.id, mentor_id: mentor.id
        expect(flash[:success]).to be_present
        expect(response).to redirect_to(team_path(team)) #redirected
        team1 = Team.find(team.id)
        expect(team1.mentor_id).to eq(mentor.id)
      end

      it 'should not accept mentor for non current student' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        user1 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user_id: user1.id, team: team)
        team.students << student
        mentor_matching = FactoryGirl.create(:mentor_matching, team_id: team.id, mentor_id: mentor.id, mentor_accepted: true)
        post :accept_mentor, id: team.id, mentor_id: mentor.id
        expect(flash[:danger]).to be_present
        expect(response).to redirect_to(root_path) #redirected
        team1 = Team.find(team.id)
        expect(team1.mentor_id).to be_nil
      end
    end

    context 'user logged in and belongs to team' do
      login_user
      it 'should not accept mentor for non existing mentor matching request' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user_id: subject.current_user.id, team: team)
        team.students << student
        post :accept_mentor, id: team.id, mentor_id: mentor.id
        expect(flash[:danger]).to be_present
        expect(response).to redirect_to(team_path(team)) #redirected
      end
    end

    context 'user logged in and belongs to team' do
      login_user
      it 'should accept mentor for incorrect mentor id' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        user1 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        mentor1 = FactoryGirl.create(:mentor, user_id: user1.id)
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user_id: subject.current_user.id, team: team)
        team.students << student
        mentor_matching = FactoryGirl.create(:mentor_matching, team_id: team.id, mentor_id: mentor.id, mentor_accepted: true)
        post :accept_mentor, id: team.id, mentor_id: mentor1.id
        expect(flash[:danger]).to be_present
        expect(response).to redirect_to(team_path(team)) #redirected
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should accept mentor' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        user1 = FactoryGirl.create(:user, email: '2@team.controller.spec', uid: '2.team.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user_id: user1.id, team: team)
        team.students << student
        mentor_matching = FactoryGirl.create(:mentor_matching, team_id: team.id, mentor_id: mentor.id, mentor_accepted: true)
        post :accept_mentor, id: team.id, mentor_id: mentor.id
        expect(flash[:success]).to be_present
        expect(response).to redirect_to(team_path(team)) #redirected
        team1 = Team.find(team.id)
        expect(team1.mentor_id).to eq(mentor.id)
      end
    end
  end

  describe 'GET #applicant_eval' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :applicant_eval
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        get :applicant_eval
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correspondeing template' do
        submit_proposal_ddl = FactoryGirl.create(:application_deadline, name: 'submit proposal deadline', submission_deadline: '2032-05-28 09:44:00')
        get :applicant_eval
        expect(response).to render_template(:applicant_eval)
      end
    end
  end

  describe 'GET #applicant_main' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :applicant_main
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        get :applicant_main
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correspondeing template' do
        peer_eval_ddl = FactoryGirl.create(:application_deadline, name: 'peer evaluation deadline', submission_deadline: '2032-05-28 09:44:00')
        result_release_date = FactoryGirl.create(:application_deadline, name: 'result release date', submission_deadline: '2032-05-28 09:44:00')
        get :applicant_main
        expect(response).to render_template(:applicant_main)
      end
    end
  end

  describe 'GET #select' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        team = FactoryGirl.create(:team)
        get :select, id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        team = FactoryGirl.create(:team)
        get :select, id: team.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correspondeing template' do
        team = FactoryGirl.create(:team)
        get :select, id: team.id
        expect(response).to render_template(:select)
      end
    end
  end

  describe 'GET #show_evaluators' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user: user)
        team = FactoryGirl.create(:team, team_name: '3.team.controller.spec', evaluator_students: [user.email])
        get :show_evaluators, id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user: user)
        team = FactoryGirl.create(:team, team_name: '3.team.controller.spec', evaluator_students: [user.email])
        get :show_evaluators, id: team.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correspondeing template' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user: user)
        team = FactoryGirl.create(:team, team_name: '3.team.controller.spec', evaluator_students: [user.email])
        get :show_evaluators, id: team.id
        expect(response).to render_template(:show_evaluators)
      end
    end
  end

  describe 'GET #edit_evaluators' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user: user)
        team = FactoryGirl.create(:team, team_name: '3.team.controller.spec', evaluator_students: [user.email])
        get :edit_evaluators, id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user: user)
        team = FactoryGirl.create(:team, team_name: '3.team.controller.spec', evaluator_students: [user.email])
        get :edit_evaluators, id: team.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correspondeing template' do
        user = FactoryGirl.create(:user, email: '1@team.controller.spec', uid: '1.team.controller.spec')
        student = FactoryGirl.create(:student, user: user)
        team = FactoryGirl.create(:team, team_name: '3.team.controller.spec', evaluator_students: [user.email])
        get :edit_evaluators, id: team.id
        expect(response).to render_template(:edit_evaluators)
      end
    end
  end

  describe 'GET #prepare_eval' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :prepare_eval
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        get :prepare_eval
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correspondeing template' do
        get :prepare_eval
        expect(response).to render_template(:prepare_eval)
      end
    end
  end

  describe 'GET #delete_evaluator' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        team = FactoryGirl.create(:team)
        get :delete_evaluator, id: team.id, evaluator_email: ''
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        team = FactoryGirl.create(:team)
        get :delete_evaluator, id: team.id, evaluator_email: ''
        expect(response).to redirect_to(controller.home_path)
      end
    end
  end

  # describe 'POST #applicant_eval_matching' do
  #   context 'admin logged in and triggers the matching' do
  #     login_admin
  #     it 'should give the correct evaluation rels' do
  #       post :applicant_eval_matching
  #     end
  #   end
  # end
end
