require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'POST #create' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        post :create, question: {
          question_type: '1',
          title: 'testing',
          instruction: 'nil',
          content: '',
          extras: '',
          survey_template_id: '1'
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render index for adviser users' do
        post :create, question: {
          question_type: '1',
          title: 'testing',
          instruction: 'nil',
          content: '',
          extras: '',
          survey_template_id: '1'
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should return error when save failed' do
        post :create, question: {
          question_type: '1',
          title: 'testing',
          instruction: 'nil',
          content: '',
          extras: '',
          survey_template_id: '1'
        }
        puts response.status
      end
    end
  end
end
