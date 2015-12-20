# PeerEvaluationsController: manage actions related to peer_evaluations
#   new:    view to create a peer_evaluation
#   create: create a peer_evaluation
#   show:   view of a peer_evaluation
#   edit:   view to update a peer_evaluation
#   update: update a peer_evaluation
class PeerEvaluationsController < ApplicationController
  def new
    evaluation = Evaluating.find(params[:target_evaluation_id]) ||
                 (record_not_found && return)
    submission = Submission.find_by(team_id: evaluation.evaluated_id,
                                    milestone_id: params[:milestone_id]) ||
                 (record_not_found && return)
    peer_evaluation = PeerEvaluation.find_by(team_id: params[:team_id],
                                             submission_id: submission.id)
    if peer_evaluation
      edit_eval_path = edit_milestone_team_peer_evaluation_path(
        params[:milestone_id], params[:team_id], peer_evaluation.id)
      redirect_to(edit_eval_path) && return
    end
    !can_access_peer_evaluation && return
    @page_title = t('.page_title')
    @peer_evaluation = PeerEvaluation.new
    render locals: {
      submission: submission,
      milestone: Milestone.find(params[:milestone_id])
    }
  end

  def create
    !can_access_peer_evaluation && return
    @peer_evaluation = PeerEvaluation.new(evaluation_params)
    if @peer_evaluation.save
      redirect_to home_path, flash: {
        success: t('.success_message')
      }
    else
      redirect_to(new_milestone_team_peer_evaluation_path(params[:milestone_id],
                                                          params[:team_id]),
                  flash: {
                    danger: t('.failure_message',
                              error_messages:
                              @peer_evaluation.errors.full_messages.join(', '))
                  })
    end
  end

  def show
    !can_access_peer_evaluation(true, true, true) && return
    @page_title = t('.page_title')
    @peer_evaluation = PeerEvaluation.find(params[:id])
  end

  def edit
    @peer_evaluation = PeerEvaluation.find(params[:id]) ||
                       (record_not_found && return)
    !can_access_peer_evaluation && return
    @page_title = t('.page_title')
    render locals: {
      milestone: Milestone.find(params[:milestone_id])
    }
  end

  def update
    !can_access_peer_evaluation && return
    if update_peer_evaluation
      redirect_to home_path, flash: {
        success: t('.success_message')
      }
    else
      dest = edit_milestone_team_peer_evaluation_path(params[:milestone_id],
                                                      params[:team_id],
                                                      @peer_evaluation.id)
      redirect_to dest, flash: {
        danger: t('.failure_message',
                  error_messages:
                  @peer_evaluation.errors.full_messages.join(', '))
      }
    end
  end

  private

  def can_access_peer_evaluation(evaluators = false, evaluateds = false,
                                 advisees = false)
    if params[:team_id]
      team = Team.find(params[:team_id]) ||
             (raise ActiveRecord::RecordNotFound.new(t('application.record_not_found_message')))
      !authenticate_user(true, false,
                         team.get_relevant_users(evaluators, evaluateds)) &&
        (return false)
    elsif params[:adviser_id]
      adviser = Adviser.find(params[:adviser_id]) ||
               (raise ActiveRecord::RecordNotFound.new(t('application.record_not_found_message')))
      if !advisees
        !authenticate_user(true, false, [adviser.user]) && (return false)
      else
        !authenticate_user(true, false,
                           adviser.advisee_users.append(adviser.user)) &&
          (return false)
      end
    else
      raise ActionController::RoutingError.new(t('application.path_not_found_message'))
    end
    true
  end

  def update_peer_evaluation
    @peer_evaluation = PeerEvaluation.find(params[:id])
    eval_params = evaluation_params
    eval_params[:submission_id] = @peer_evaluation.submission_id
    @peer_evaluation.update(eval_params) ? @peer_evaluation : nil
  end

  def evaluation_params
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
end
