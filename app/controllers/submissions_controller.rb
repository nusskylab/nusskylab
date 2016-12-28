# SubmissionsController: manage actions related submission
#   new:    view to create a submission
#   create: create a submission
#   show:   view of a submission
#   edit:   view to update a submission
#   update: update a submission
class SubmissionsController < ApplicationController
  def new
    team = Team.find(params[:team_id]) || (record_not_found && return)
    milestone = Milestone.find_by(id: params[:milestone_id]) ||
                (record_not_found && return)
    submission = Submission.find_by(team_id: team.id,
                                    milestone_id: milestone.id)
    if submission
      edit_submission_path = edit_milestone_team_submission_path(
        milestone, team, submission)
      redirect_to(edit_submission_path) && return
    end
    !authenticate_user(true, false,
                       team.get_relevant_users(false, false)) && return
    @page_title = t('.page_title')
    @submission = Submission.new(team_id: params[:team_id])
    render locals: {
      team_id: params[:team_id],
      milestone: milestone,
      submissions: Submission.where(team_id: team.id)
    }
  end

  def create
    team = Team.find(params[:team_id]) || (record_not_found && return)
    milestone = Milestone.find_by(id: params[:milestone_id]) ||
                (record_not_found && return)
    !authenticate_user(true, false,
                       team.get_relevant_users(false, false)) && return
    @submission = Submission.new(submission_params)
    if @submission.save
      redirect_to home_path, flash: {
        success: t('.success_message')
      }
    elsif empty_input_field?
      render :new, locals: {
        team_id: params[:team_id],
        milestone: milestone,
        submissions: Submission.where(team_id: team.id)
      }
    else
      redirect_to new_milestone_team_submission_path(milestone, team), flash: {
        danger: t('.failure_message',
                  error_message: @submission.errors.full_messages.join(', '))
      }
    end
  end

  def show
    team = Team.find(params[:team_id]) || (record_not_found && return)
    @submission = Submission.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       team.get_relevant_users(true, false)) && return
    @page_title = t('.page_title')
  end

  def edit
    team = Team.find(params[:team_id]) || (record_not_found && return)
    @submission = Submission.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       team.get_relevant_users(false, false)) && return
    @page_title = t('.page_title')
    render locals: {
      team_id: params[:team_id],
      submissions: Submission.where(team_id: team.id)
    }
  end

  def update
    team = Team.find(params[:team_id]) || (record_not_found && return)
    milestone = Milestone.find_by(id: params[:milestone_id]) ||
                (record_not_found && return)
    @submission = Submission.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       team.get_relevant_users(false, false)) && return
    if update_submission
      redirect_to home_path, flash: {
        success: t('.success_message')
      }
    elsif empty_input_field?
      render :edit, locals: {
        team_id: params[:team_id],
        milestone: milestone,
        submissions: Submission.where(team_id: team.id)
      }
    else
      edit_submission_path = edit_milestone_team_submission_path(milestone,
                                                                 team,
                                                                 @submission)
      redirect_to edit_submission_path, flash: {
        danger: t('.failure_message',
                  error_message: @submission.errors.full_messages.join(', '))
      }
    end
  end

  private

  def update_submission
    sub_params = submission_params
    sub_params[:milestone_id] = @submission.milestone_id
    sub_params[:team_id] = @submission.team_id
    @submission.update(sub_params) ? @submission : nil
  end

  def empty_input_field?
    @submission.errors[:project_log].any? || 
    @submission.errors[:read_me].any? || 
    @submission.errors[:video_link].any?
  end

  def submission_params
    submission_params = params.require(:submission).permit(:milestone_id,
                                                           :read_me,
                                                           :project_log,
                                                           :video_link)
    submission_params[:team_id] = params[:team_id]
    submission_params[:milestone_id] = params[:milestone_id]
    submission_params
  end
end
