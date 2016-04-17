require 'rails_helper'

RSpec.describe SurveyTemplatesController, type: :controller do
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

  describe 'GET #new' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        get :new
        expect(response).to redirect_to(controller.home_path)
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
      it 'should redirect to home_path for non_admin' do
        post :create
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect with success' do
        milestone = FactoryGirl.create(:milestone, name: 'Milestone 1')
        post :create, survey_template: {
          milestone_id: milestone.id,
          survey_type: '1',
          instruction: 'nil',
          deadline: '2015-08-08 16:24:49'
        }
        expect(response).to redirect_to(survey_templates_path)
        expect(flash[:success]).not_to be_nil
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

    context 'user logged in and admin' do
      login_admin
      it 'should render with correct template' do
        milestone = FactoryGirl.create(:milestone, name: 'Milestone 1')
        survey_template = FactoryGirl.create(
          :survey_template, milestone: milestone
        )
        get :edit, id: survey_template.id, survey_template: {
          milestone_id: milestone.id,
          survey_type: '1',
          instruction: 'nil',
          deadline: '2015-08-08 16:24:49'
        }
        expect(response).to render_template(:edit)
      end
    end
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

    context 'user logged in and admin' do
      login_admin
      it 'should render with correct template' do
        milestone = FactoryGirl.create(:milestone, name: 'Milestone 1')
        survey_template = FactoryGirl.create(
          :survey_template, milestone: milestone
        )
        put :update, id: survey_template.id, survey_template: {
          milestone_id: milestone.id,
          survey_type: '1',
          instruction: 'nil',
          deadline: '2015-08-08 16:24:49'
        }
        expect(response).to redirect_to(survey_templates_path)
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
      it 'should redirect to home_path for non_admin' do
        get :show, id: 1
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render with correct template' do
        milestone = FactoryGirl.create(:milestone, name: 'Milestone 1')
        survey_template = FactoryGirl.create(
          :survey_template, milestone: milestone
        )
        get :show, id: survey_template.id
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #preview' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :preview, id: 1
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render correct template' do
        milestone = FactoryGirl.create(:milestone, name: 'Milestone 1')
        survey_template = FactoryGirl.create(
          :survey_template, milestone: milestone
        )
        get :preview, id: survey_template.id
        expect(response).to render_template(:preview)
      end
    end
  end
end
