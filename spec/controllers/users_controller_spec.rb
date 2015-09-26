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
      it 'should redirect to home_link for non_admin' do
        get :index
        expect(response).to redirect_to(controller.get_home_link)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should assign @users' do
        get :index
        expect(assigns(:users).length).to eql 1
        expect(assigns(:users)[0].id).to eql User.all[0].id
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
      it 'should redirect to home_link for non_admin' do
        get :new
        expect(response).to redirect_to(controller.get_home_link)
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
      it 'should redirect to home_link for non_admin' do
        post :create
        expect(response).to redirect_to(controller.get_home_link)
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

      it 'should redirect to home_link if accessing other\'s page' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        get :show, id: user.id
        expect(response).to redirect_to(controller.get_home_link)
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
      it 'should redirect to home_link for non_admin' do
        post :preview_as, id: 1
        expect(response).to redirect_to(controller.get_home_link)
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

      it 'should redirect to home_link if accessing other\'s page' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        get :edit, id: user.id
        expect(response).to redirect_to(controller.get_home_link)
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
      it 'should redirect to home_link for non_admin' do
        user = FactoryGirl.create(:user, email: '1@user.controller.spec', uid: '1.user.controller.spec')
        put :update, id: user.id
        expect(response).to redirect_to(controller.get_home_link)
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
      it 'should redirect to home_link for non_admin' do
        delete :destroy, id: 1
        expect(response).to redirect_to(controller.get_home_link)
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
end
