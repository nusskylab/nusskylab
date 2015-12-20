require 'rails_helper'

RSpec.describe MilestonesController, type: :controller do
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
      it 'should assign @milestones' do
        get :index
        expect(assigns(:milestones).length).to eql Milestone.all.length
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
      it 'should redirect to mentors with success for admin user' do
        milestone = FactoryGirl.attributes_for(:milestone, name: 'milestone_1.milestone.controller.spec')
        post :create, milestone: milestone
        expect(response).to redirect_to(milestones_path)
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to admins with danger for admin user' do
        FactoryGirl.create(:milestone, name: 'milestone_2.milestone.controller.spec')
        milestone = FactoryGirl.attributes_for(:milestone, name: 'milestone_2.milestone.controller.spec')
        post :create, milestone: milestone
        expect(response).to redirect_to(new_milestone_path)
        expect(flash[:danger]).not_to be_nil
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
      it 'should render new for admin user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_2.milestone.controller.spec')
        get :edit, id: milestone.id
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
      it 'should redirect to mentors with success for admin user' do
        m = FactoryGirl.create(:milestone, name: 'milestone_2.milestone.controller.spec')
        milestone = FactoryGirl.attributes_for(:milestone, name: 'milestone_1.milestone.controller.spec')
        put :update, id: m.id, milestone: milestone
        expect(response).to redirect_to(milestones_path)
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to admins with danger for admin user' do
        m = FactoryGirl.create(:milestone, name: 'milestone_2.milestone.controller.spec')
        FactoryGirl.create(:milestone, name: 'milestone_1.milestone.controller.spec')
        milestone = FactoryGirl.attributes_for(:milestone, name: 'milestone_1.milestone.controller.spec')
        put :update, id: m.id, milestone: milestone
        expect(response).to redirect_to(edit_milestone_path(m.id))
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
      it 'should redirect to home_path for non_admin' do
        get :show, id: 1
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render show for admin user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_2.milestone.controller.spec')
        get :show, id: milestone.id
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
      it 'should redirect to home_path for non_admin' do
        delete :destroy, id: 1
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect with success for admin user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_2.milestone.controller.spec')
        delete :destroy, id: milestone.id
        expect(response).to redirect_to(milestones_path)
        expect(flash[:success]).not_to be_nil
      end
    end
  end
end
