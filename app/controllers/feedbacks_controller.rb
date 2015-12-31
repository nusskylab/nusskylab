# FeedbackController: manage actions related to feedbacks
#   new:    view to create a feedback
#   create: create a feedback
#   edit:   view to edit a feedback
#   update: update a feedback
class FeedbacksController < ApplicationController
  def new
    team = Team.find(params[:team_id])
    !authenticate_user(true, false, team.get_relevant_users(false, false)) && return
    @page_title = t('.page_title')
    @feedback = Feedback.new
    evaluators = []
    team.evaluators.each do |evaluator|
      evaluators.append(evaluator.evaluator)
    end
    # TODO: need to properly handle this!!!
    feedback_template = SurveyTemplate.all[0]
    render locals: {
      advisers: [team.adviser],
      evaluators: evaluators,
      feedback_template: feedback_template
    }
  end

  def create
    team = Team.find(params[:team_id])
    !authenticate_user(true, false, team.get_relevant_users(false, false)) && return
    if create_or_update_feedback_and_responses
      redirect_to home_path, flash: {
        success: t('.success_message')
      }
    else
      redirect_to home_path, flash: {
        danger: t('.failure_message',
                  error_message: @feedback.errors.full_messages.join(', '))
      }
    end
  end

  def edit
    team = Team.find(params[:team_id])
    !authenticate_user(true, false, team.get_relevant_users(false, false)) && return
    @page_title = t('.page_title')
    @feedback = Feedback.find(params[:id])
    evaluators = []
    team.evaluators.each do |evaluator|
      evaluators.append(evaluator.evaluator)
    end
    # TODO: need to properly handle this!!!
    feedback_template = SurveyTemplate.all[0]
    render locals: {
      advisers: [team.adviser],
      evaluators: evaluators,
      feedback_template: feedback_template
    }
  end

  def update
    team = Team.find(params[:team_id])
    !authenticate_user(true, false, team.get_relevant_users(false, false)) && return
    @feedback = Feedback.find(params[:id])
    if create_or_update_feedback_and_responses(@feedback)
      redirect_to home_path, flash: {
        success: t('.success_message')
      }
    else
      redirect_to home_path, flash: {
        danger: t('.failure_message',
                  error_message: @feedback.errors.full_messages.join(', '))
      }
    end
  end

  private

  def feedback_params
    feedback_ps = params.require(:feedback).permit!
    feedback_ps[:team_id] = params[:team_id]
    if feedback_ps[:feedback_to_team] == 'on'
      feedback_ps.except!(:adviser_id)
    else
      feedback_ps.except!(:target_team_id)
    end
    feedback_ps = {} if feedback_ps[:edit] == 'on'
    feedback_ps.except!(:feedback_to_team)
    feedback_ps
  end

  def questions_params
    params.require(:questions).permit!
  end

  def create_or_update_feedback_and_responses(feedback = nil)
    if feedback.nil?
      @feedback = Feedback.new(feedback_params)
      feedback_template = SurveyTemplate.all[0]
      @feedback.survey_template_id = feedback_template.id
    else
      feedback.update(feedback_params)
      @feedback = feedback
    end
    @feedback.response_content = questions_params.to_json
    if !@feedback.target_team_id.nil?
      @feedback.target_type = Feedback.target_types[:target_type_team]
    elsif !@feedback.adviser_id.nil?
      @feedback.target_type = Feedback.target_types[:target_type_adviser]
    end
    @feedback.save ? @feedback : nil
  end
end
