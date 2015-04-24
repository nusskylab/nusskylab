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

  def edit
    @submission = Submission.find(params[:id])
    render locals: {
             milestones: Milestone.all
           }
  end

  def update
    @submission = create_or_update_submission
    redirect_to team_submission_path(@submission.team_id, @submission.id)
  end

  private
  def create_or_update_submission
    submission_params = params.require(:submission).permit(:milestone_id, :read_me, :project_log, :video_link)
    submission_params[:team_id] = params[:team_id]
    Submission.create_or_update_by_team_id_and_milestone_id(submission_params)
  end
end
