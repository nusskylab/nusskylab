class FeedbacksController < ApplicationController
  layout 'general_layout'

  def index
    check_access(true, false)
    @feedbacks = Feedback.where(team_id: params[:team_id])
  end

  def new
    check_access(true, false)
    team = Team.find(params[:team_id])
    @feedback = Feedback.new
    evaluators = []
    team.evaluators.each do |evaluator|
      evaluators.append(evaluator.evaluator)
    end
    render locals: {
             advisers: [team.adviser],
             evaluators: evaluators
           }
  end

  def create
    check_access(true, false)
    if create_feedback_and_responses
      redirect_to team_feedbacks_path(team_id: params[:team_id]), flash: {success: 'Feedback is saved successfully'}
    else
      redirect_to new_team_feedback_path(team_id: params[:team_id]),
                  flash: {danger: 'Feedback could not be saved: <br>&nbsp;&nbsp;&nbsp;&nbsp;' +
                    @feedback.errors.full_messages.join(', ')}
    end
  end

  private
  def get_feedback_params
    feedback_params = params.require(:feedback).permit!
    feedback_params[:team_id] = params[:team_id]
    if feedback_params[:feedback_to_team] == 'on'
      feedback_params.except!(:adviser_id)
    else
      feedback_params.except!(:target_team_id)
    end
    feedback_params.except!(:feedback_to_team)
    feedback_params
  end

  def create_feedback_and_responses
    # TODO: create responses for feedback
    @feedback = Feedback.new(get_feedback_params)
    if not @feedback.target_team_id.nil?
      @feedback.target_type = Feedback.target_types[:target_type_team]
    elsif not @feedback.adviser_id.nil?
      @feedback.target_type = Feedback.target_types[:target_type_adviser]
    end
    @feedback.save ? @feedback : nil
  end
end
