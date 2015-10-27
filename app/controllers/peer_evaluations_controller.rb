class PeerEvaluationsController < ApplicationController
  def new
    evaluation = Evaluating.find(params[:target_evaluation_id]) or record_not_found
    submission = Submission.find_by(team_id: evaluation.evaluated_id, milestone_id: params[:milestone_id]) or record_not_found
    not can_access_peer_evaluation and return
    @page_title = t('.page_title')
    @peer_evaluation = PeerEvaluation.new
    render locals: {
             submission: submission,
             milestone: Milestone.find(params[:milestone_id])
           }
  end

  def create
    not can_access_peer_evaluation and return
    @page_title = t('.page_title')
    create_peer_evaluation
    response_to_user(true)
  end

  def show
    not can_access_peer_evaluation(true, true, true) and return
    @page_title = t('.page_title')
    @peer_evaluation = PeerEvaluation.find(params[:id])
  end

  def edit
    not can_access_peer_evaluation and return
    @page_title = t('.page_title')
    @peer_evaluation = PeerEvaluation.find(params[:id])
    render locals: {
             milestone: Milestone.find(params[:milestone_id])
           }
  end

  def update
    not can_access_peer_evaluation and return
    @page_title = t('.page_title')
    update_peer_evaluation
    response_to_user(false)
  end

  private
  def can_access_peer_evaluation(evaluators = false, evaluateds = false, advisees = false)
    if params[:team_id]
      team = Team.find(params[:team_id]) or record_not_found
      not authenticate_user(true, false, team.get_relevant_users(evaluators, evaluateds)) and return false
    elsif params[:adviser_id]
      adviser = Adviser.find(params[:adviser_id]) or record_not_found
      if not advisees
        not authenticate_user(true, false, [adviser.user]) and return false
      else
        not authenticate_user(true, false, adviser.get_advisee_users.append(adviser.user)) and return false
      end
    else
      raise ActionController::RoutingError.new(t('application.path_not_found_message'))
    end
    return true
  end

  def create_peer_evaluation
    @peer_evaluation = PeerEvaluation.new(get_evaluation_params)
    @peer_evaluation.save ? @peer_evaluation : nil
  end

  def update_peer_evaluation
    @peer_evaluation = PeerEvaluation.find(params[:id])
    eval_params = get_evaluation_params
    eval_params[:submission_id] = @peer_evaluation.submission_id
    @peer_evaluation.update(eval_params) ? @peer_evaluation : nil
  end

  def get_evaluation_params
    eval_params = params.require(:peer_evaluation).permit(:public_content,
                                                          :private_content,
                                                          :submission_id,
                                                          :published)
    if params[:team_id]
      eval_params[:team_id] = params[:team_id]
    elsif params[:adviser_id]
      eval_params[:adviser_id] = params[:adviser_id]
    end
    eval_params
  end

  def get_submissions_for_page
    if params[:team_id]
      get_submissions_for_team
    elsif params[:adviser_id]
      get_submissions_for_adviser
    end
  end

  def get_submissions_for_team
    team = Team.find(params[:team_id])
    evaluateds = team.evaluateds
    submissions = []
    evaluateds.each do |evaluated|
      submissions += evaluated.evaluated.submissions
    end
    submissions.select { |sub| sub.milestone_id.to_s == params[:milestone_id].to_s }
  end

  def get_submissions_for_adviser
    adviser = Adviser.find(params[:adviser_id])
    teams = adviser.teams
    submissions = []
    teams.each do |team|
      submissions += team.submissions
    end
    submissions.select { |sub| sub.milestone_id.to_s == params[:milestone_id].to_s }
  end

  def render_template(template_name)
    render template_name, locals: {
             submissions: get_submissions_for_page,
             milestone: Milestone.find(params[:milestone_id])
           }
  end

  def response_to_user(is_create_action = true)
    if @peer_evaluation.errors.any?
      if is_create_action
        render_template('new')
      else
        render_template('edit')
      end
    else
      if @peer_evaluation[:team_id]
        redirect_to team_path(@peer_evaluation[:team_id])
      elsif @peer_evaluation[:adviser_id]
        redirect_to adviser_path(@peer_evaluation[:adviser_id])
      end
    end
  end
end
