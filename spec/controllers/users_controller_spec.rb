require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'GET #index' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        get :index
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should assign @users' do
        get :index
        expect(assigns(:users).length).to eql User.all.length
      end

      it 'should render index for admin user' do
        get :index
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
      it 'should redirect with success when params are fine' do
        user = {user_name: 'test_user', email: '1@user.controller.spec', uid: '1.user.controller.spec', provider: 'NUS'}
        post :create, user: user
        expect(response).to redirect_to(users_path)
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect with failure when params are not fine' do
        user = {user_name: 'test_user', email: 'user.controller.spec', uid: '1.user.controller.spec', provider: 'NUS'}
        post :create, user: user
        expect(response).to redirect_to(new_user_path)
        expect(flash[:danger]).not_to be_nil
      end
    end
  end

  describe 'GET #show' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        get :show, id: user.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render show if accessing own page' do
        get :show, id: subject.current_user.id
        expect(response).to render_template(:show)
      end

      it 'should redirect to home_path if accessing other\'s page' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        get :show, id: user.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render show when provided id is fine' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        get :show, id: user.id
        expect(response).to render_template(:show)
      end

      it 'should redirect with 404 when id is wrong' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        get :show, id: (user.id + 1)
        expect(response.status).to eql 404
      end
    end
  end

  describe 'POST #preview_as' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        post :preview_as, id: 1
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        post :preview_as, id: 1
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect with success when provided id is fine' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        post :preview_as, id: user.id
        expect(response).to redirect_to(user_path(user.id))
      end

      it 'should redirect with 404 when id is wrong' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        post :preview_as, id: (user.id + 1)
        expect(response.status).to eql 404
      end
    end
  end

  describe 'GET #register_as_student' do
    context 'user not logged in' do
      it 'should redirect to 404 if requested user does not exist' do
        get :register_as_student, id: 1
        expect(response.status).to eql 404
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render correct template' do
        milestone = FactoryGirl.create(:milestone, name: 'Milestone 1')
        FactoryGirl.create(
          :survey_template,
          milestone: milestone,
          survey_type: SurveyTemplate.survey_types[:survey_type_registration]
        )
        get :register_as_student, id: subject.current_user.id
        expect(response).to render_template(:register_as_student)
      end
    end
  end

  describe 'POST #register' do
    context 'user not logged in' do
      it 'should redirect to 404 if requested user does not exist' do
        post :register, id: 1
        expect(response.status).to eql 404
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect_to users path' do
        milestone = FactoryGirl.create(:milestone, name: 'Milestone 1')
        FactoryGirl.create(
          :survey_template,
          milestone: milestone,
          survey_type: SurveyTemplate.survey_types[:survey_type_registration]
        )
        post :register, id: subject.current_user.id, questions: {'1': 'test', '2': '2'}
        expect(response).to redirect_to(user_path(subject.current_user))
      end
    end
  end

  describe 'GET #register_as_team:' do
    context 'user not logged in:' do
      it 'should redirect to 404 if requested user does not exist' do
        get :register_as_team, id: 1
        expect(response.status).to eql 404
      end
    end

    context 'user logged in but not admin:' do
      login_user
      it 'should handle different cases for user' do
        get :register_as_team, id: subject.current_user.id
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:danger]).not_to be_nil

        student = FactoryGirl.create(:student, user: subject.current_user, application_status: false)
        get :register_as_team, id: subject.current_user.id
        expect(response).to render_template(:register_as_team)
      end
    end
  end

  describe 'POST #register_team' do
    context 'user not logged in' do
      it 'should redirect to 404 if requested user does not exist' do
        post :register_team, id: 1
        expect(response.status).to eql 404
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should handle different cases for user' do
        post :register_team, id: subject.current_user.id, team: {
          email: 'non_existing@user.controller.spec'
        }
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:danger]).not_to be_nil

        post :register_team, id: subject.current_user.id, team: {
          email: 'default_user@controller.spec'
        }
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:danger]).not_to be_nil

        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        post :register_team, id: subject.current_user.id, team: {
          email: '1@user.controller.spec'
        }
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:danger]).not_to be_nil

        team = FactoryGirl.create(:team, team_name: '1.user.controller.spec')
        student = FactoryGirl.create(:student, user: user, team: team, application_status: true)
        post :register_team, id: subject.current_user.id, team: {
          email: '1@user.controller.spec'
        }
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:danger]).not_to be_nil

        student.team_id = nil
        student.save
        post :register_team, id: subject.current_user.id, team: {
          email: '1@user.controller.spec'
        }
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:danger]).not_to be_nil

        FactoryGirl.create(:student, user: subject.current_user, application_status: true, team: nil)
        post :register_team, id: subject.current_user.id, team: {
          email: '1@user.controller.spec'
        }
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:success]).not_to be_nil
      end
    end
  end

  describe 'POST #confirm_team' do
    context 'user not logged in' do
      it 'should redirect to 404 if requested user does not exist' do
        post :confirm_team, id: 1
        expect(response.status).to eql 404
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should handle different cases' do
        post :confirm_team, id: subject.current_user.id, team: {'confirm': 'true'}
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:danger]).not_to be_nil

        current_user = subject.current_user
        team = FactoryGirl.create(:team, team_name: '1.user.controller.spec')
        student = FactoryGirl.create(:student, user: current_user, team: team, application_status: true)
        post :confirm_team, id: current_user.id, team: {'confirm': 'false'}
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:success]).not_to be_nil
        expect(Student.find_by(user_id: current_user.id).team_id).to be_nil

        team = FactoryGirl.create(:team, team_name: '2.user.controller.spec')
        student.team_id = team.id
        student.save
        post :confirm_team, id: current_user.id, team: {'confirm': 'true'}
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:success]).not_to be_nil
      end
    end
  end

  describe 'GET #edit' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        get :edit, id: user.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render edit if accessing own page' do
        get :edit, id: subject.current_user.id
        expect(response).to render_template(:edit)
      end

      it 'should redirect to home_path if accessing other\'s page' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        get :edit, id: user.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render edit when provided id is fine' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        get :edit, id: user.id
        expect(response).to render_template(:edit)
      end

      it 'should redirect with 404 when id is wrong' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        get :edit, id: (user.id + 1)
        expect(response.status).to eql 404
      end
    end
  end

  describe 'PUT #update' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        put :update, id: user.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        put :update, id: user.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect to user\'s page with success when params are fine' do
        user_params = {user_name: 'test_user', email: '1@user.controller.spec', uid: '2.user.controller.spec', provider: 'NUS'}
        put :update, id: subject.current_user.id, user: user_params
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(User.find_by(email: '1@user.controller.spec').uid).to eql 'https://openid.nus.edu.sg/2.user.controller.spec'
      end

      it 'should redirect to user\'s page with failure when params are not fine' do
        user_params = {user_name: 'test_user', email: 'user.controller.spec', uid: '2.user.controller.spec', provider: 'NUS'}
        put :update, id: subject.current_user.id, user: user_params
        expect(response).to redirect_to(user_path(subject.current_user))
        expect(flash[:danger]).not_to be_nil
      end

      it 'should redirect with 404 when id is wrong' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        put :update, id: (user.id + 1)
        expect(response.status).to eql 404
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        delete :destroy, id: 1
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        delete :destroy, id: 1
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect to users\' page when provided id is fine' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        delete :destroy, id: user.id
        expect(response).to redirect_to(users_path)
      end

      it 'should redirect with 404 when id is wrong' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        delete :destroy, id: (user.id + 1)
        expect(response.status).to eql 404
      end
    end
  end

  describe 'POST #confirm_purge_and_open' do
    context 'purge button is triggered' do
      login_admin
      user1 = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
      user2 = FactoryGirl.create(:user, email: '2@user.controller.spec', uid: '2.user.controller.spec')
      team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
      student1 = FactoryGirl.create(:student, user: user1, team: team, evaluatee_ids: [team.id])
      student2 = FactoryGirl.create(:student, user: user2, team: team, evaluatee_ids: [team.id])
      team.students << student1
      team.students << student2
      team.save
      it 'should purge successful students, teams and evaluating rels' do
        post :confirm_purge_and_open
        expect(Team.all.length).to eql(0)
        expect(Student.all.length).to eql(0)
        expect(flash[:success]).not_to be_nil
        expect(response).to redirect_to(applicant_main_teams_path)
      end
    end
  end

  describe 'GET #purge_and_open' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :purge_and_open
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        get :purge_and_open
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correspondeing template' do
        get :purge_and_open
        expect(response).to render_template(:purge_and_open)
      end
    end
  end
end
