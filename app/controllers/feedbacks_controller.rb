class FeedbacksController < ApplicationController
  def new
    check_access(true, false)
    team = Team.find(params[:team_id])
    @feedback = Feedback.new
    evaluators = []
    team.evaluators.each do |evaluator|
      evaluators.append(evaluator.evaluator)
    end
    # TODO: need to properly handle this!!!
    feedback_template = SurveyTemplate.all()[0]
    render locals: {
             advisers: [team.adviser],
             evaluators: evaluators,
             feedback_template: feedback_template
           }
  end

  def create
    check_access(true, false)
    if create_or_update_feedback_and_responses
      redirect_to get_home_link, flash: {success: t('.success_message')}
    else
      redirect_to get_home_link,
                  flash: {danger: t('.failure_message') + @feedback.errors.full_messages.join(', ')}
    end
  end

  def edit
    check_access(true, false)
    team = Team.find(params[:team_id])
    @feedback = Feedback.find(params[:id])
    evaluators = []
    team.evaluators.each do |evaluator|
      evaluators.append(evaluator.evaluator)
    end
    # TODO: need to properly handle this!!!
    feedback_template = SurveyTemplate.all()[0]
    render locals: {
             advisers: [team.adviser],
             evaluators: evaluators,
             feedback_template: feedback_template
           }
  end

  def update
    check_access(true, false)
    @feedback = Feedback.find(params[:id])
    if create_or_update_feedback_and_responses(@feedback)
      redirect_to get_home_link, flash: {success: t('.success_message')}
    else
      redirect_to get_home_link,
                  flash: {danger: t('.failure_message') + @feedback.errors.full_messages.join(', ')}
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
    if feedback_params[:edit] == 'on'
      feedback_params = {}
    end
    feedback_params.except!(:feedback_to_team)
    feedback_params
  end

  def get_questions_params
    questions_params = params.require(:questions).permit!
  end

  def create_or_update_feedback_and_responses(feedback = nil)
    if feedback.nil?
      @feedback = Feedback.new(get_feedback_params)
      feedback_template = SurveyTemplate.all()[0]
      @feedback.survey_template_id = feedback_template.id
    else
      feedback.update(get_feedback_params)
      @feedback = feedback
    end
    @feedback.response_content = get_questions_params.to_json
    if not @feedback.target_team_id.nil?
      @feedback.target_type = Feedback.target_types[:target_type_team]
    elsif not @feedback.adviser_id.nil?
      @feedback.target_type = Feedback.target_types[:target_type_adviser]
    end
    @feedback.save ? @feedback : nil
  end
end
