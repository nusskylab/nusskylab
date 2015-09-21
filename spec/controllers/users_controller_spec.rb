require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #index" do
    it 'should redirect to root_path for non-user' do
      get :index
      expect(response).to redirect_to(root_path)
    end
  end
end
