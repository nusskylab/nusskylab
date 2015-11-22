class PeerEvaluationsController < ApplicationController
  def new
    evaluation = Evaluating.find(params[:target_evaluation_id]) or (record_not_found and return)
    submission = Submission.find_by(team_id: evaluation.evaluated_id,
                                    milestone_id: params[:milestone_id]) or (record_not_found and return)
    peer_evaluation = PeerEvaluation.find_by(team_id: params[:team_id], submission_id: submission.id)
    redirect_to edit_milestone_team_peer_evaluation_path(params[:milestone_id], params[:team_id], peer_evaluation.id) and return if peer_evaluation
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
    @peer_evaluation = PeerEvaluation.new(get_evaluation_params)
    if @peer_evaluation.save
      redirect_to get_home_link, flash: {success: t('.success_message')}
    else
      redirect_to new_milestone_team_peer_evaluation_path(params[:milestone_id],
                                                          params[:team_id]), flash: {danger: t('.failure_message',
                                                                                     error_messages: @peer_evaluation.errors.full_messages.join(', '))}
    end
  end

  def show
    not can_access_peer_evaluation(true, true, true) and return
    @page_title = t('.page_title')
    @peer_evaluation = PeerEvaluation.find(params[:id])
  end

  def edit
    @peer_evaluation = PeerEvaluation.find(params[:id]) or record_not_found
    not can_access_peer_evaluation and return
    @page_title = t('.page_title')
    render locals: {
             milestone: Milestone.find(params[:milestone_id])
           }
  end

  def update
    not can_access_peer_evaluation and return
    if update_peer_evaluation
      redirect_to get_home_link, flash: {success: t('.success_message')}
    else
      redirect_to edit_milestone_team_peer_evaluation_path(params[:milestone_id],
                                                           params[:team_id],
                                                           @peer_evaluation.id), flash: {danger: t('.failure_message',
                                                                                         error_messages: @peer_evaluation.errors.full_messages.join(', '))}
    end
  end

  private
  def can_access_peer_evaluation(evaluators = false, evaluateds = false, advisees = false)
    if params[:team_id]
      team = Team.find(params[:team_id]) or (raise ActiveRecord::RecordNotFound.new(t('application.record_not_found_message')))
      not authenticate_user(true, false, team.get_relevant_users(evaluators, evaluateds)) and return false
    elsif params[:adviser_id]
      adviser = Adviser.find(params[:adviser_id]) or (raise ActiveRecord::RecordNotFound.new(t('application.record_not_found_message')))
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

  def update_peer_evaluation
    @peer_evaluation = PeerEvaluation.find(params[:id])
    eval_params = get_evaluation_params
    eval_params[:submission_id] = @peer_evaluation.submission_id
    @peer_evaluation.update(eval_params) ? @peer_evaluation : nil
  end

  def get_evaluation_params
    eval_params = params.require(:peer_evaluation).permit(:public_content, :private_content,
                                                          :submission_id, :published)
    if params[:team_id]
      eval_params[:team_id] = params[:team_id]
    elsif params[:adviser_id]
      eval_params[:adviser_id] = params[:adviser_id]
    end
    eval_params
  end
end
