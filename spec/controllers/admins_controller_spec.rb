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
      it 'should assign @admins' do
        get :index
        expect(assigns(:admins).length).to eql Admin.all.length
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
      it 'should redirect to admins with success for admin user' do
        user = FactoryGirl.create(:user, email: '1@admin.controller.spec', uid: '1.admin.controller.spec')
        post :create, admin: {user_id: user.id}
        expect(response).to redirect_to(admins_path)
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to new admin with danger for admin user' do
        post :create, admin: {user_id: subject.current_user.id}
        expect(response).to redirect_to(new_admin_path)
        expect(flash[:danger]).not_to be_nil
      end
    end
  end

  describe 'GET #show' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :show, id: 1
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_link for non_admin' do
        get :show, id: 1
        expect(response).to redirect_to(controller.get_home_link)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render show for admin user' do
        admin = Admin.find_by(user_id: subject.current_user.id)
        get :show, id: admin.id
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
      it 'should redirect to home_link for non_admin' do
        delete :destroy, id: 1
        expect(response).to redirect_to(controller.get_home_link)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect with success for admin user' do
        user = FactoryGirl.create(:user, email: '2@admin.controller.spec', uid: '2.admin.controller.spec')
        admin = FactoryGirl.create(:admin, user_id: user.id)
        delete :destroy, id: admin.id
        expect(response).to redirect_to(admins_path)
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect with failure for admin user' do
        admin = Admin.find_by(user_id: subject.current_user.id)
        delete :destroy, id: admin.id
        expect(response).to redirect_to(admins_path)
        expect(flash[:danger]).not_to be_nil
      end
    end
  end
end
