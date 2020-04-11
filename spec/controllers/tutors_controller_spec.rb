require 'rails_helper'

RSpec.describe TutorsController, type: :controller do
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
      it 'should assign @tutors' do
        get :index
        expect(assigns(:roles).length).to eql Tutor.all.length
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
      it 'should redirect to tutors with success for admin user' do
        user = FactoryGirl.create(
          :user,
          email: '1@tutor.controller.spec',
          uid: '1.tutor.controller.spec'
        )
        post :create, tutor: { user_id: user.id }
        expect(response).to redirect_to(
          tutors_path(cohort: controller.current_cohort)
        )
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to admins with danger for admin user' do
        FactoryGirl.create(
          :tutor,
          user_id: controller.current_user.id,
          cohort: controller.current_cohort
        )
        post :create, tutor: { user_id: controller.current_user.id }
        expect(response).to redirect_to(
          new_tutor_path(cohort: controller.current_cohort)
        )
        expect(flash[:danger]).not_to be_nil
      end
    end
  end

  describe 'GET #show' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '2@tutor.controller.spec', uid: '2.tutor.controller.spec')
        tutor = FactoryGirl.create(:tutor, user_id: user.id)
        get :show, id: tutor.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render show for current tutor' do
        tutor = FactoryGirl.create(:tutor, user_id: controller.current_user.id)
        get :show, id: tutor.id
        expect(response).to render_template(:show)
        Tutor.find_by(user_id: controller.current_user.id).destroy
      end

      it 'should redirect to home_path for non_admin' do
        user = FactoryGirl.create(:user, email: '2@tutor.controller.spec', uid: '2.tutor.controller.spec')
        tutor = FactoryGirl.create(:tutor, user_id: user.id)
        get :show, id: tutor.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render show for admin user' do
        user = FactoryGirl.create(:user, email: '2@tutor.controller.spec', uid: '2.tutor.controller.spec')
        tutor = FactoryGirl.create(:tutor, user_id: user.id)
        get :show, id: tutor.id
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
        user = FactoryGirl.create(:user, email: '2@tutor.controller.spec', uid: '2.tutor.controller.spec')
        tutor = FactoryGirl.create(:tutor, user_id: user.id)
        delete :destroy, id: tutor.id
        expect(response).to redirect_to(tutors_path(cohort: controller.current_cohort))
        expect(flash[:success]).not_to be_nil
      end
    end
  end
end
