require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  describe 'GET #index' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render index for adviser users' do
        adviser1 = FactoryGirl.create(:adviser, user_id: subject.current_user.id)
        user1 = FactoryGirl.create(:user, email: '1@student.controller.spec', uid: '1.student.controller.spec')
        user2 = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        team1 = FactoryGirl.create(:team, adviser: adviser1, team_name: '1.student.controller.spec')
        team2 = FactoryGirl.create(:team, adviser: adviser1, team_name: '2.student.controller.spec')
        student1 = FactoryGirl.create(:student, user: user1, team: team1)
        student2 = FactoryGirl.create(:student, user: user2, team: team2)
        get :index
        expect(response).to render_template(:index)
        expect(assigns(:roles).length).to eql Student.all.length
      end

      it 'should redirect to home_path for non_admin and non_adviser' do
        get :index
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should assign @students' do
        get :index
        expect(assigns(:roles).length).to eql Student.all.length
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
        user = FactoryGirl.create(:user, email: '1@student.controller.spec', uid: '1.student.controller.spec')
        post :create, student: {user_id: user.id}
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin' do
        user = FactoryGirl.create(:user, email: '1@student.controller.spec', uid: '1.student.controller.spec')
        post :create, student: {user_id: user.id}
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect to students with success for admin user' do
        user = FactoryGirl.create(:user, email: '1@student.controller.spec', uid: '1.student.controller.spec')
        post :create, student: {user_id: user.id}
        expect(response).to redirect_to(students_path(cohort: controller.current_cohort))
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to admins with danger for admin user' do
        student = FactoryGirl.create(:student, user_id: subject.current_user.id)
        post :create, student: {user_id: subject.current_user.id}
        expect(response).to redirect_to(new_student_path(cohort: controller.current_cohort))
        expect(flash[:danger]).not_to be_nil
      end
    end
  end

  describe 'GET #show' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        student = FactoryGirl.create(:student, user_id: user.id)
        get :show, id: student.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render show for current student' do
        # TODO: check more on the locals of student show page
        student = FactoryGirl.create(:student, user_id: subject.current_user.id)
        get :show, id: student.id
        expect(response).to render_template(:show)
      end

      it 'should redirect to home_path for non_admin and non_current_user' do
        user = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        student = FactoryGirl.create(:student, user_id: user.id)
        get :show, id: student.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render show for admin user' do
        user = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        student = FactoryGirl.create(:student, user_id: user.id)
        get :show, id: student.id
        expect(response).to render_template(:show)
      end
    end
  end

  describe 'GET #edit' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        student = FactoryGirl.create(:student, user_id: user.id)
        get :edit, id: student.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin and non_current_user' do
        user = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        student = FactoryGirl.create(:student, user_id: user.id)
        get :edit, id: student.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render edit for admin user' do
        user = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        student = FactoryGirl.create(:student, user_id: user.id)
        get :edit, id: student.id
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PUT #update' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        user = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        student = FactoryGirl.create(:student, user_id: user.id)
        put :update, id: student.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path for non_admin and non_current_user' do
        user = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        student = FactoryGirl.create(:student, user_id: user.id)
        put :update, id: student.id
        expect(response).to redirect_to(controller.home_path)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should update student for admin user' do
        user = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        student = FactoryGirl.create(:student, user_id: user.id)
        team = FactoryGirl.create(:team, team_name: '1.student.controller.spec')
        put :update, id: student.id, student: {team_id: team.id}
        expect(response).to redirect_to(students_path(cohort: controller.current_cohort))
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

    context 'user logged in and admin and user does not belong to team' do
      login_admin
      it 'should redirect with success for admin user' do
        user = FactoryGirl.create(:user, email: '2@student.controller.spec', uid: '2.student.controller.spec')
        student = FactoryGirl.create(:student, user_id: user.id)
        delete :destroy, id: student.id
        expect(response).to redirect_to(students_path(cohort: controller.current_cohort))
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect with success for admin user for deletion of student with team' do
        adv_user = FactoryGirl.create(:user, email: '1@advisor.controller.spec', uid: '5.advisor.controller.spec')        
        adviser1 = FactoryGirl.create(:adviser, user_id: adv_user.id)
        user1 = FactoryGirl.create(:user, email: '3@student.controller.spec', uid: '3.student.controller.spec')
        user2 = FactoryGirl.create(:user, email: '4@student.controller.spec', uid: '4.student.controller.spec')
        team1 = FactoryGirl.create(:team, adviser: adviser1, team_name: '2.student.controller.spec')
        student1 = FactoryGirl.create(:student, user_id: user1.id, team: team1)
        student2 = FactoryGirl.create(:student, user_id: user2.id, team: team1)
        delete :destroy, id: student1.id
        
        # expect successful deletion of team
        expect(response).to redirect_to(students_path(cohort: controller.current_cohort))
        expect(flash[:success]).not_to be_nil

        # expect the team record to be deleted
        expect{ team1.reload }.to raise_error ActiveRecord::RecordNotFound
        # check that student 1 is deleted
        expect{ student1.reload }.to raise_error ActiveRecord::RecordNotFound
        # check second student exists and has no team 
        expect( student2.reload.team ).to be_nil
      end

    end
  end
end
