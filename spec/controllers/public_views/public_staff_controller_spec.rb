require 'rails_helper'

RSpec.describe PublicViews::PublicStaffController, type: :controller do
  describe 'GET #index' do
    context 'user not logged in' do
      it 'should render correct template' do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end
end
