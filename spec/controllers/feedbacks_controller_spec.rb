require 'rails_helper'

RSpec.describe FeedbacksController, type: :controller do
  describe 'GET #new' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        team = FactoryGirl.create(
          :team, adviser: nil, team_name: '1.survey_template.controller.spec'
        )
        get :new, team_id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render new template for student with access privilege' do
        team = FactoryGirl.create(
          :team,
          adviser: nil,
          team_name: '1.survey_template.controller.spec',
          cohort: controller.current_cohort
        )
        milestone = FactoryGirl.create(
          :milestone, name: 'Milestone 3', cohort: controller.current_cohort
        )
        survey_template = FactoryGirl.create(
          :survey_template,
          milestone: milestone,
          survey_type: SurveyTemplate.survey_types[:survey_type_feedback]
        )
        FactoryGirl.create(
          :feedback, survey_template: survey_template, team: team
        )
        FactoryGirl.create(
          :student, team: team, user_id: controller.current_user.id
        )
        get :new, team_id: team.id
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #create' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        team = FactoryGirl.create(
          :team, adviser: nil, team_name: '1.survey_template.controller.spec'
        )
        post :create, team_id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path with success for student' do
        team = FactoryGirl.create(
          :team,
          adviser: nil,
          team_name: '1.survey_template.controller.spec',
          cohort: controller.current_cohort
        )
        target_team = FactoryGirl.create(
          :team,
          adviser: nil,
          team_name: '2.survey_template.controller.spec',
          cohort: controller.current_cohort
        )
        milestone = FactoryGirl.create(
          :milestone, name: 'Milestone 3', cohort: controller.current_cohort
        )
        survey_template = FactoryGirl.create(
          :survey_template,
          milestone: milestone,
          survey_type: SurveyTemplate.survey_types[:survey_type_feedback]
        )
        FactoryGirl.create(
          :feedback, survey_template: survey_template, team: team
        )
        FactoryGirl.create(
          :student, team: team, user_id: controller.current_user.id
        )
        post :create, team_id: team.id, questions: {
          '1': 'test'
        }, feedback: {
          feedback_to_team: 'on',
          target_team_id: target_team.id
        }
        expect(response).to redirect_to(controller.home_path)
        expect(flash[:success]).not_to be_nil
      end
    end
  end

  describe 'GET #edit' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        team = FactoryGirl.create(
          :team,
          adviser: nil,
          team_name: '1.survey_template.controller.spec',
          cohort: controller.current_cohort
        )
        milestone = FactoryGirl.create(
          :milestone, name: 'Milestone 3', cohort: controller.current_cohort
        )
        survey_template = FactoryGirl.create(
          :survey_template,
          milestone: milestone,
          survey_type: SurveyTemplate.survey_types[:survey_type_feedback]
        )
        feedback = FactoryGirl.create(
          :feedback, survey_template: survey_template, team: team
        )
        get :edit, id: feedback.id, team_id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should render edit template for student with access privilege' do
        team = FactoryGirl.create(
          :team,
          adviser: nil,
          team_name: '1.survey_template.controller.spec',
          cohort: controller.current_cohort
        )
        milestone = FactoryGirl.create(
          :milestone, name: 'Milestone 3', cohort: controller.current_cohort
        )
        survey_template = FactoryGirl.create(
          :survey_template,
          milestone: milestone,
          survey_type: SurveyTemplate.survey_types[:survey_type_feedback]
        )
        feedback = FactoryGirl.create(
          :feedback, survey_template: survey_template, team: team
        )
        FactoryGirl.create(
          :student, team: team, user_id: controller.current_user.id
        )
        get :edit, id: feedback.id, team_id: team.id
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'PUT #update' do
    context 'user not logged in' do
      it 'should redirect to root_path for non_user' do
        team = FactoryGirl.create(
          :team,
          adviser: nil,
          team_name: '1.survey_template.controller.spec',
          cohort: controller.current_cohort
        )
        milestone = FactoryGirl.create(
          :milestone, name: 'Milestone 3', cohort: controller.current_cohort
        )
        survey_template = FactoryGirl.create(
          :survey_template,
          milestone: milestone,
          survey_type: SurveyTemplate.survey_types[:survey_type_feedback]
        )
        feedback = FactoryGirl.create(
          :feedback, survey_template: survey_template, team: team
        )
        put :update, id: feedback.id, team_id: team.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'user logged in but not admin' do
      login_user
      it 'should redirect to home_path with success for student' do
        team = FactoryGirl.create(
          :team,
          adviser: nil,
          team_name: '1.survey_template.controller.spec',
          cohort: controller.current_cohort
        )
        target_team = FactoryGirl.create(
          :team,
          adviser: nil,
          team_name: '2.survey_template.controller.spec',
          cohort: controller.current_cohort
        )
        milestone = FactoryGirl.create(
          :milestone, name: 'Milestone 3', cohort: controller.current_cohort
        )
        survey_template = FactoryGirl.create(
          :survey_template,
          milestone: milestone,
          survey_type: SurveyTemplate.survey_types[:survey_type_feedback]
        )
        feedback = FactoryGirl.create(
          :feedback, survey_template: survey_template, team: team
        )
        FactoryGirl.create(
          :student, team: team, user_id: controller.current_user.id
        )
        put :update, id: feedback.id, team_id: team.id, questions: {
          '1': 'test'
        }, feedback: {
          feedback_to_team: 'on',
          target_team_id: target_team.id
        }
        expect(response).to redirect_to(controller.home_path)
        expect(flash[:success]).not_to be_nil
      end
    end
  end
end
