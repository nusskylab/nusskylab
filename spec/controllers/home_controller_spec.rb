require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    context 'user not logged in' do
      it 'should render home page for non_user' do
        get :index
        expect(response).to render_template(:index)
      end
    end
    
    context 'user logged in but not admin' do
      login_user
      it 'should render home page for non_admin' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render home page for admin user' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end
