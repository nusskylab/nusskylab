class PeerEvaluationsController < ApplicationController
  def index
    @peer_evaluations = PeerEvaluation.all
  end

  def new
    @peer_evaluation = PeerEvaluation.new
    render locals: {
             submissions: get_submissions_for_team_to_evaluate
           }
  end

  def create
    peer_evaluation = create_peer_evaluation
    redirect_to team_peer_evaluations_path(params[:team_id])
  end

  def show
    @peer_evaluation = PeerEvaluation.find(params[:id])
  end

  def edit
    @peer_evaluation = PeerEvaluation.find(params[:id])
    render locals: {
             submissions: get_submissions_for_team_to_evaluate
           }
  end

  def update
    peer_evaluation = update_peer_evaluation
    redirect_to team_peer_evaluations_path(params[:team_id])
  end

  def destroy
    @peer_evaluation = PeerEvaluation.find(params[:id])
    @peer_evaluation.destroy
    redirect_to team_peer_evaluations_path(params[:team_id])
  end

  private
  def create_peer_evaluation
    @peer_evaluation = PeerEvaluation.new(get_evaluation_params)
    @peer_evaluation.save ? @peer_evaluation : nil
  end

  def update_peer_evaluation
    # TODO: check for duplicate submissions
    @peer_evaluation = PeerEvaluation.find(params[:id])
    @peer_evaluation.update(get_evaluation_params) ? @peer_evaluation : nil
  end

  def get_evaluation_params
    eval_params = params.require(:peer_evaluation).permit(:public_content,
                                                          :private_content,
                                                          :submission_id,
                                                          :published)
    eval_params[:team_id] = params[:team_id]
    eval_params[:submitted_date] = Date.today
    eval_params
  end

  def get_submissions_for_team_to_evaluate
    team = Team.find(params[:team_id])
    evaluateds = team.evaluateds
    submissions = []
    evaluateds.each do |evaluated|
      submissions += evaluated.evaluated.submissions
    end
    submissions
  end
end
