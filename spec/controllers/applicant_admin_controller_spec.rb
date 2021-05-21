require 'rails_helper'

RSpec.describe ApplicantAdminController, type: :controller do
  describe 'GET #purge_and_open' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :purge_and_open
        expect(response).to redirect_to(root_path)
      end
    end
  end
end