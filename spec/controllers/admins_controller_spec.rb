require 'rails_helper'

RSpec.describe AdminsController, type: :controller do
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
        expect(assigns(:admins).length).to eql 1
        expect(assigns(:admins)[0].id).to eql Admin.all[0].id
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
      it 'should redirect to admins for admin user' do
        post :create
        expect(response).to redirect_to(admins_path)
      end
    end
  end

  describe 'POST #use_existing' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        post :use_existing
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_link for non_admin' do
        post :use_existing
        expect(response).to redirect_to(controller.get_home_link)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect_to admins for admin user' do
        post :use_existing
        expect(response).to redirect_to(admins_path)
      end
    end
  end
end
