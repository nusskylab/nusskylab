class SubmissionsController < ApplicationController
  def new
    team = Team.find(params[:team_id]) or (record_not_found and return)
    milestone = Milestone.find_by(id: params[:milestone_id]) or (record_not_found and return)
    submission = Submission.find_by(team_id: team.id, milestone_id: milestone.id)
    redirect_to edit_milestone_team_submission_path(milestone, team, submission) and return if submission
    not authenticate_user(true, false, team.get_relevant_users(false, false)) and return
    @page_title = t('.page_title')
    @submission = Submission.new(team_id: params[:team_id])
    render locals: {team_id: params[:team_id],
                    milestone: milestone,
                    submissions: Submission.where(team_id: team.id)}
  end

  def create
    team = Team.find(params[:team_id]) or (record_not_found and return)
    milestone = Milestone.find_by(id: params[:milestone_id]) or (record_not_found and return)
    not authenticate_user(true, false, team.get_relevant_users(false, false)) and return
    @submission = Submission.new(get_submission_params)
    if @submission.save
      redirect_to home_path, flash: {
        success: t('.success_message')
      }
    else
      redirect_to new_milestone_team_submission_path(milestone, team), flash: {danger: t('.failure_message',
                                                                               error_messages: @submission.errors.full_messages.join(', '))}
    end
  end

  def show
    team = Team.find(params[:team_id]) or (record_not_found and return)
    @submission = Submission.find(params[:id]) or (record_not_found and return)
    not authenticate_user(true, false, team.get_relevant_users(true, false)) and return
    @page_title = t('.page_title')
  end

  def edit
    team = Team.find(params[:team_id]) or (record_not_found and return)
    @submission = Submission.find(params[:id]) or (record_not_found and return)
    not authenticate_user(true, false, team.get_relevant_users(false, false)) and return
    @page_title = t('.page_title')
    render locals: {team_id: params[:team_id], submissions: Submission.where(team_id: team.id)}
  end

  def update
    team = Team.find(params[:team_id]) or (record_not_found and return)
    milestone = Milestone.find_by(id: params[:milestone_id]) or (record_not_found and return)
    @submission = Submission.find(params[:id]) or (record_not_found and return)
    not authenticate_user(true, false, team.get_relevant_users(false, false)) and return
    if update_submission
      redirect_to home_path, flash: {
        success: t('.success_message')
      }
    else
      redirect_to edit_milestone_team_submission_path(milestone, team, @submission), flash: {danger: t('.failure_message',
                                                                                             error_messages: @submission.errors.full_messages.join(', '))}
    end
  end

  private
  def update_submission
    sub_params = get_submission_params
    sub_params[:milestone_id] = @submission.milestone_id
    sub_params[:team_id] = @submission.team_id
    @submission.update(sub_params) ? @submission : nil
  end

  def get_submission_params
    submission_params = params.require(:submission).permit(:milestone_id, :read_me,
                                                           :project_log, :video_link)
    submission_params[:team_id] = params[:team_id]
    submission_params[:milestone_id] = params[:milestone_id]
    submission_params
  end
end
