class PeerEvaluationsController < ApplicationController
  def index
    @peer_evaluations = PeerEvaluation.all
  end

  def new
    @peer_evaluation = PeerEvaluation.new
    render locals: {
             team: Team.find(params[:team_id])
           }
  end

  def create
    @peer_evaluation = create_or_update_peer_evaluation
    redirect_to team_peer_evaluations_path(params[:team_id])
  end

  def show
    @peer_evaluation = PeerEvaluation.find(params[:id])
    render locals: {
             team: Team.find(params[:team_id])
           }
  end

  private
  def create_or_update_peer_evaluation
    team_id = params[:team_id]
    submission_id = params[:submission_id]
    public_content = params[:public_content]
    private_content = params[:private_content]
    peer_evaluation = PeerEvaluation.new(team_id: team_id,
                                         submission_id: submission_id,
                                         public_content: public_content,
                                         private_content: private_content)
    peer_evaluation.save
    peer_evaluation
  end
end
