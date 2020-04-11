require 'rails_helper'

RSpec.describe EvaluatingsController, type: :controller do
  describe 'GET #index' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render for advisers' do
        FactoryGirl.create(:adviser, user: controller.current_user)
        get :index
        expect(response).to render_template(:index)
      end

      it 'should redirect to home_path for non_admin' do
        get :index
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correct template' do
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
      it 'should render for advisers' do
        FactoryGirl.create(:adviser, user: controller.current_user)
        get :new
        expect(response).to render_template(:new)
      end

      it 'should redirect to home_path for non_admin' do
        get :new
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render correct template' do
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
        adviser = FactoryGirl.create(:adviser, user: controller.current_user)
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec', adviser: adviser
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec', adviser: adviser
        )
        post :create, evaluating: {
          evaluated_id: team1.id,
          evaluator_id: team2.id
        }
        expect(response).to redirect_to(evaluatings_path)
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to home_path for non_admin' do
        post :create
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect to admins with success for admin user' do
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec'
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec'
        )
        post :create, evaluating: {
          evaluated_id: team1.id,
          evaluator_id: team2.id
        }
        expect(response).to redirect_to(evaluatings_path)
        expect(flash[:success]).not_to be_nil
      end
    end
  end

  describe 'GET #edit' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec', adviser: nil
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec', adviser: nil
        )
        evaluating = FactoryGirl.create(
          :evaluating, evaluator: team1, evaluated: team2
        )
        get :edit, id: evaluating.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render for advisers' do
        adviser = FactoryGirl.create(:adviser, user: controller.current_user)
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec', adviser: adviser
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec', adviser: adviser
        )
        evaluating = FactoryGirl.create(
          :evaluating, evaluator: team1, evaluated: team2
        )
        get :edit, id: evaluating.id
        expect(response).to render_template(:edit)
      end

      it 'should redirect to home_path for non_admin' do
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec', adviser: nil
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec', adviser: nil
        )
        evaluating = FactoryGirl.create(
          :evaluating, evaluator: team1, evaluated: team2
        )
        get :edit, id: evaluating.id
        expect(response).to redirect_to(controller.home_path)
      end
    end
  end

  describe 'PUT #update' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec', adviser: nil
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec', adviser: nil
        )
        evaluating = FactoryGirl.create(
          :evaluating, evaluator: team1, evaluated: team2
        )
        post :update, id: evaluating.id, evaluating: {
          evaluated_id: team1.id,
          evaluator_id: team2.id
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        adviser = FactoryGirl.create(:adviser, user: controller.current_user)
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec', adviser: adviser
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec', adviser: adviser
        )
        evaluating = FactoryGirl.create(
          :evaluating, evaluator: team1, evaluated: team2
        )
        post :update, id: evaluating.id, evaluating: {
          evaluated_id: team1.id,
          evaluator_id: team2.id
        }
        expect(response).to redirect_to(evaluatings_path)
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to home_path for non_admin' do
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec', adviser: nil
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec', adviser: nil
        )
        evaluating = FactoryGirl.create(
          :evaluating, evaluator: team1, evaluated: team2
        )
        post :update, id: evaluating.id, evaluating: {
          evaluated_id: team1.id,
          evaluator_id: team2.id
        }
        expect(response).to redirect_to(controller.home_path)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec', adviser: nil
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec', adviser: nil
        )
        evaluating = FactoryGirl.create(
          :evaluating, evaluator: team1, evaluated: team2
        )
        delete :destroy, id: evaluating.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect for adviser' do
        adviser = FactoryGirl.create(:adviser, user: controller.current_user)
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec', adviser: adviser
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec', adviser: adviser
        )
        evaluating = FactoryGirl.create(
          :evaluating, evaluator: team1, evaluated: team2
        )
        delete :destroy, id: evaluating.id
        expect(response).to redirect_to(evaluatings_path)
      end

      it 'should redirect to home_path for non_admin' do
        team1 = FactoryGirl.create(
          :team, team_name: '1.evaluating.controller.spec', adviser: nil
        )
        team2 = FactoryGirl.create(
          :team, team_name: '2.evaluating.controller.spec', adviser: nil
        )
        evaluating = FactoryGirl.create(
          :evaluating, evaluator: team1, evaluated: team2
        )
        delete :destroy, id: evaluating.id
        expect(response).to redirect_to(controller.home_path)
      end
    end
  end
end
