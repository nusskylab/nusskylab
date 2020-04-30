require 'rails_helper'

RSpec.describe MentorsController, type: :controller do
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
      it 'should assign @mentors' do
        get :index
        expect(assigns(:roles).length).to eql Mentor.all.length
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
      it 'should redirect to mentors with success for admin user' do
        user = FactoryGirl.create(:user, email: '1@mentor.controller.spec', uid: '1.mentor.controller.spec')
        post :create, mentor: {user_id: user.id}
        expect(response).to redirect_to(mentors_path(cohort: controller.current_cohort))
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to admins with danger for admin user' do
        mentor = FactoryGirl.create(:mentor, user_id: subject.current_user.id)
        post :create, mentor: {user_id: subject.current_user.id}
        expect(response).to redirect_to(new_mentor_path(cohort: controller.current_cohort))
        expect(flash[:danger]).not_to be_nil
      end
    end
  end

  describe 'GET #show' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '2@mentor.controller.spec', uid: '2.mentor.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        get :show, id: mentor.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render show for current mentor' do
        # TODO: check more on the locals of mentor show page
        mentor = FactoryGirl.create(:mentor, user_id: subject.current_user.id)
        get :show, id: mentor.id
        expect(response).to render_template(:show)
        Mentor.find_by(user_id: subject.current_user.id).destroy
      end

      it 'should redirect to home_path for non_admin' do
        user = FactoryGirl.create(:user, email: '2@mentor.controller.spec', uid: '2.mentor.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        get :show, id: mentor.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render show for admin user' do
        user = FactoryGirl.create(:user, email: '2@mentor.controller.spec', uid: '2.mentor.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        get :show, id: mentor.id
        expect(response).to render_template(:show)
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
      it 'should redirect with success for admin user' do
        user = FactoryGirl.create(:user, email: '2@mentor.controller.spec', uid: '2.mentor.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        delete :destroy, id: mentor.id
        expect(response).to redirect_to(mentors_path(cohort: controller.current_cohort))
        expect(flash[:success]).not_to be_nil
      end
    end
  end

  describe 'POST #accept_team' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '1@mentor.controller.spec', uid: '1.mentor.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        post :accept_team, params: {team: team.id}, id: mentor.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should accept team successfully for mentor user' do
        mentor = FactoryGirl.create(:mentor, user_id: subject.current_user.id)
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        mentor_matching = FactoryGirl.create(:mentor_matching, team_id: team.id, mentor_id: mentor.id)
        post :accept_team, team: team.id, id: mentor.id
        expect(flash[:success]).to be_present
        expect(response).to redirect_to(mentor_path(mentor)) #redirected
      end

      it 'should not accept team successfully for non-mentor user' do
        user = FactoryGirl.create(:user, email: '1@mentor.controller.spec', uid: '1.mentor.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        post :accept_team, team: team.id, id: mentor.id
        expect(flash[:danger]).to be_present
        expect(response).to redirect_to(controller.home_path) #redirected
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should accept team successfully for admins' do
        user = FactoryGirl.create(:user, email: '1@mentor.controller.spec', uid: '1.mentor.controller.spec')
        mentor = FactoryGirl.create(:mentor, user_id: user.id)
        team = FactoryGirl.create(:team, team_name: '1.team.controller.spec')
        mentor_matching = FactoryGirl.create(:mentor_matching, team_id: team.id, mentor_id: mentor.id)
        post :accept_team, team: team.id, id: mentor.id
        expect(flash[:success]).to_not be_nil
        expect(response.status).to eq(302)
      end
    end
  end
end
