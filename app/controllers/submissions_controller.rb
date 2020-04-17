# SubmissionsController: manage actions related submission
#   new:    view to create a submission
#   create: create a submission
#   show:   view of a submission
#   edit:   view to update a submission
#   update: update a submission
class SubmissionsController < ApplicationController
  def index
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    @teams_table = {}
    teams = Team.where(cohort: current_cohort, has_dropped: false)
    @teams_table["vostok"] = teams.select{|team| team.vostok?}
    @teams_table["project_gemini"] = teams.select{|team| team.project_gemini?}
    @teams_table["apollo_11"] = teams.select{|team| team.apollo_11?}
    @teams_table["artemis"] = teams.select{|team| team.artemis?}
  end

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
    @submission = Submission.new(submission_params(milestone))
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
    team = @submission.team # To prevent unauthorized access through URL manipulation.
    !authenticate_user(true, false,
                       team.get_relevant_users(true, false)) && return
    @page_title = t('.page_title', team_name: team.team_name)
  end

  def edit
    team = Team.find(params[:team_id]) || (record_not_found && return)
    @submission = Submission.find(params[:id]) || (record_not_found && return)
    team = @submission.team # To prevent unauthorized access through URL manipulation.
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
    team = @submission.team # To prevent unauthorized access through URL manipulation.
    !authenticate_user(true, false,
                       team.get_relevant_users(false, false)) && return
    if update_submission(milestone)
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
    # render plain: params[:submission].inspect
  end

  private

  def update_submission(milestone)
    sub_params = submission_params(milestone)
    sub_params[:milestone_id] = @submission.milestone_id
    sub_params[:team_id] = @submission.team_id
    @submission.update(sub_params) ? @submission : nil
  end

  def empty_input_field?
    @submission.errors[:project_log].any? ||
    @submission.errors[:read_me].any? ||
    @submission.errors[:video_link].any?
  end

  def submission_params(milestone)
    submission_params = params.require(:submission).permit(:milestone_id,
                                                           :read_me,
                                                           :project_log,
                                                           :video_link,
                                                           :poster_link,
                                                           :milestone_number)
    submission_params[:team_id] = params[:team_id]
    submission_params[:milestone_id] = params[:milestone_id]
    submission_params[:milestone_number] = get_milestone_number(milestone)
    submission_params
  end

  def get_milestone_number(milestone)
    milestone.name[-1].to_i
  end
end
