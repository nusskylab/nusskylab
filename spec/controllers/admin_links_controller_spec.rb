require 'rails_helper'

RSpec.describe AdminLinksController, type: :controller do
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

      it 'should render index for admin user' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'GET #edit' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :edit, id: 1
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        get :edit, id: 1
        expect(response).to redirect_to(controller.home_path)
      end
    end

    # context 'user logged in and admin' do
    #   login_admin
    #   it 'should render new for admin user' do
    #     @deadline = ApplicationDeadline.first
    #     get :edit, id: @deadline.id
    #     expect(response).to render_template(:edit)
    #   end
    # end
  end

  describe 'PUT #update' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        put :update, id: 1
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        put :update, id: 1
        expect(response).to redirect_to(controller.home_path)
      end
    end

    # context 'user logged in and admin' do
    #   login_admin
    #   it 'should redirect to mentors with success for admin user' do
    #     expect(flash[:success]).not_to be_nil
    #   end
    # end
  end
end
