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
      it 'should redirect_to home_path for non_admin users' do
        post :create, question: {
          question_type: '1',
          title: 'testing',
          instruction: 'nil',
          content: '',
          extras: '',
          survey_template_id: '1'
        }
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correct template' do
        survey_template = FactoryGirl.create(:survey_template)
        post :create, question: {
          question_type: '1',
          title: 'testing',
          instruction: 'nil',
          content: '',
          extras: '',
          survey_template_id: survey_template.id
        }
        expect(response.status).to eql 200
      end
    end
  end

  describe 'PUT #update' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        put :update, id: 1, question: {
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
      it 'should redirect_to home_path for non_admin users' do
        put :update, id: 1, question: {
          question_type: '1',
          title: 'testing',
          instruction: 'nil',
          content: '',
          extras: '',
          survey_template_id: '1'
        }
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correct template' do
        survey_template = FactoryGirl.create(:survey_template)
        question = FactoryGirl.create(
          :question, survey_template: survey_template
        )
        put :update, id: question.id, question: {
          question_type: '1',
          title: 'testing',
          instruction: 'nil',
          content: '',
          extras: '',
          survey_template_id: survey_template.id
        }
        expect(response.status).to eql 200
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
      it 'should redirect_to home_path for non_admin users' do
        delete :destroy, id: 1
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correct template' do
        survey_template = FactoryGirl.create(:survey_template)
        question = FactoryGirl.create(
          :question, survey_template: survey_template
        )
        delete :destroy, id: question.id
        expect(response.status).to eql 200
      end
    end
  end
end
