class SubmissionsController < ApplicationController
  def index
  end

  def new
    @submission = Submission.new(team_id: params[:team_id])
    render locals: {
             milestones: Milestone.all
           }
  end

  def create
    @submission = create_or_update_submission
    redirect_to team_submission_path(@submission.team_id, @submission.id)
  end

  def show
    @submission = Submission.find(params[:id])
    render locals: {
             milestones: Milestone.all
           }
  end

  private
  def create_or_update_submission
    team_id = params[:team_id]
    milestone_id = params[:milestone_id]
    content = params[:content]
    Submission.create_or_update_by_team_id_and_milestone_id(team_id: team_id,
                                                            milestone_id: milestone_id,
                                                            content: content)
  end
end
