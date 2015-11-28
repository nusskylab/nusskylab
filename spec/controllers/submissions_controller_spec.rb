require 'rails_helper'

RSpec.describe SubmissionsController, type: :controller do
  describe 'GET #new' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        get :new, team_id: team.id, milestone_id: milestone.id
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'user logged in but not admin' do
      login_user
      it 'should render new template for student with access privilege' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        student = FactoryGirl.create(:student, team: team, user_id: subject.current_user.id)
        get :new, team_id: team.id, milestone_id: milestone.id
        expect(response).to render_template(:new)
      end

      it 'should redirect to home_link for non_admin and non_current_user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        get :new, team_id: team.id, milestone_id: milestone.id
        expect(response).to redirect_to(controller.get_home_link)
      end
    end

    context 'user logged in and student' do
      login_user
      it 'should redirect_to to edit submission page if submission existed' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '2@submission.controller.spec', uid: '2.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '2.submission.controller.spec')
        student = FactoryGirl.create(:student, team: team, user_id: subject.current_user.id)
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        get :new, team_id: team.id, milestone_id: milestone.id
        expect(response).to redirect_to(edit_milestone_team_submission_path(milestone.id, team.id, submission.id))
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render new for admin user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        get :new, team_id: team.id, milestone_id: milestone.id
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submisison_params = {read_me: 'This is read me', project_log: 'project_log', video_link: 'google.com'}
        post :create, team_id: team.id, milestone_id: milestone.id, submission: submisison_params
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_link with success for student' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        student = FactoryGirl.create(:student, team: team, user_id: subject.current_user.id)
        submisison_params = {read_me: 'This is read me', project_log: 'project_log', video_link: 'google.com'}
        post :create, team_id: team.id, milestone_id: milestone.id, submission: submisison_params
        expect(response).to redirect_to(controller.get_home_link)
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to home_link for non_admin and non_current_user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submisison_params = {read_me: 'This is read me', project_log: 'project_log', video_link: 'google.com'}
        post :create, team_id: team.id, milestone_id: milestone.id, submission: submisison_params
        expect(response).to redirect_to(controller.get_home_link)
      end
    end

    context 'user logged in and student' do
      login_user
      it 'should redirect to new_milestone_team_submission_path with danger for student' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        student = FactoryGirl.create(:student, team: team, user_id: subject.current_user.id)
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        submisison_params = {read_me: 'This is read me', project_log: 'project_log', video_link: 'google.com'}
        post :create, team_id: team.id, milestone_id: milestone.id, submission: submisison_params
        expect(response).to redirect_to(new_milestone_team_submission_path(milestone, team))
        expect(flash[:danger]).not_to be_nil
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect to mentors with success for admin user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submisison_params = {read_me: 'This is read me', project_log: 'project_log', video_link: 'google.com'}
        post :create, team_id: team.id, milestone_id: milestone.id, submission: submisison_params
        expect(response).to redirect_to(controller.get_home_link)
        expect(flash[:success]).not_to be_nil
      end
    end
  end

  describe 'GET #edit' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        get :edit, id: submission.id ,team_id: team.id, milestone_id: milestone.id
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'user logged in but not admin' do
      login_user
      it 'should render edit template for student with access privilege' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        student = FactoryGirl.create(:student, team: team, user_id: subject.current_user.id)
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        get :edit, id: submission.id ,team_id: team.id, milestone_id: milestone.id
        expect(response).to render_template(:edit)
      end

      it 'should redirect to home_link for non_admin and non_current_user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        get :edit, id: submission.id ,team_id: team.id, milestone_id: milestone.id
        expect(response).to redirect_to(controller.get_home_link)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render edit for admin user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        get :edit, id: submission.id ,team_id: team.id, milestone_id: milestone.id
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PUT #update' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        submisison_params = {read_me: 'This is read me', project_log: 'project_log', video_link: 'google.com'}
        put :update, id: submission.id, team_id: team.id, milestone_id: milestone.id, submission: submisison_params
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_link with success for student' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        student = FactoryGirl.create(:student, team: team, user_id: subject.current_user.id)
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        submisison_params = {read_me: 'This is read me', project_log: 'project_log', video_link: 'google.com'}
        put :update, id: submission.id, team_id: team.id, milestone_id: milestone.id, submission: submisison_params
        expect(response).to redirect_to(controller.get_home_link)
        expect(flash[:success]).not_to be_nil
      end

      it 'should redirect to home_link for non_admin and non_current_user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        submisison_params = {read_me: 'This is read me', project_log: 'project_log', video_link: 'google.com'}
        put :update, id: submission.id, team_id: team.id, milestone_id: milestone.id, submission: submisison_params
        expect(response).to redirect_to(controller.get_home_link)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should redirect to mentors with success for admin user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        submisison_params = {read_me: 'This is read me', project_log: 'project_log', video_link: 'google.com'}
        put :update, id: submission.id, team_id: team.id, milestone_id: milestone.id, submission: submisison_params
        expect(response).to redirect_to(controller.get_home_link)
        expect(flash[:success]).not_to be_nil
      end
    end
  end

  describe 'GET #show' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        get :show, id: submission.id ,team_id: team.id, milestone_id: milestone.id
        expect(response).to redirect_to(root_path)
      end
    end
    
    context 'user logged in but not admin' do
      login_user
      it 'should render show template for student with access privilege' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        student = FactoryGirl.create(:student, team: team, user_id: subject.current_user.id)
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        get :show, id: submission.id ,team_id: team.id, milestone_id: milestone.id
        expect(response).to render_template(:show)
      end

      it 'should redirect to home_link for non_admin and non_current_user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        get :show, id: submission.id ,team_id: team.id, milestone_id: milestone.id
        expect(response).to redirect_to(controller.get_home_link)
      end
    end

    context 'user logged in and admin' do
      login_admin
      it 'should render show for admin user' do
        milestone = FactoryGirl.create(:milestone, name: 'milestone_1.submission.controller.spec')
        user0 = FactoryGirl.create(:user, email: '1@submission.controller.spec', uid: '1.submission.controller.spec')
        adviser = FactoryGirl.create(:adviser, user: user0)
        team = FactoryGirl.create(:team, adviser: adviser, team_name: '1.submission.controller.spec')
        submission = FactoryGirl.create(:submission, team: team, milestone: milestone)
        get :show, id: submission.id ,team_id: team.id, milestone_id: milestone.id
        expect(response).to render_template(:show)
      end
    end
  end
end
