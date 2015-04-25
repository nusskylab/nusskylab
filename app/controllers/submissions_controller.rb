class SubmissionsController < ApplicationController
  def index
    @submissions = Submission.all
  end

  def new
    @submission = Submission.new(team_id: params[:team_id])
    render_new_action and return
  end

  def create
    sub = create_submission
    render_or_redirect_for_submission(sub, true)
  end

  def show
    @submission = Submission.find(params[:id])
  end

  def edit
    @submission = Submission.find(params[:id])
    render_edit_action and return
  end

  def update
    sub = update_submission
    render_or_redirect_for_submission(sub, false)
  end

  private
  def create_submission
    sub_params = exact_submission_params
    @submission = Submission.new(sub_params)
    @submission.save ? @submission : nil
  end

  def update_submission
    sub_params = exact_submission_params
    @submission = Submission.find(params[:id])
    if not (@submission.milestone_id == sub_params[:milestone_id].to_i)
      @submission.errors.add(:milestone_id,
                             'You cannot change milestone id once submitted, use new instead')
      return nil
    elsif not (@submission.team_id == sub_params[:team_id].to_i)
      @submission.errors.add(:team_id,
                             'You cannot change team id once submitted, use new instead')
      return nil
    end
    @submission.update(sub_params) ? @submission : nil
  end

  def exact_submission_params
    submission_params = params.require(:submission).permit(:milestone_id, :read_me, :project_log, :video_link)
    submission_params[:team_id] = params[:team_id]
    submission_params
  end

  def render_or_redirect_for_submission(sub, is_create_action)
    if sub
      redirect_to team_submission_path(@submission.team_id, @submission.id)
    elsif is_create_action
      render_new_action
    else
      render_edit_action
    end
  end

  def render_new_action
    render 'new', locals: {
             milestones: Milestone.all
                }
  end

  def render_edit_action
    render 'edit', locals: {
             milestones: Milestone.all
                 }
  end
end
