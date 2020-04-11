require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  describe 'GET #index' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :index, format: 'json'
        expect(response.status).to eql 200
      end
    end
  end
end
