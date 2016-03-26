# TeamsController
class TeamsController < ApplicationController
  def index
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    cohort = params[:cohort] || current_cohort
    @teams = Team.order(:team_name).where(cohort: cohort)
    @page_title = t('.page_title')
    respond_to do |format|
      format.html do
        render locals: {
          all_cohorts: all_cohorts,
          cohort: cohort
        }
      end
      format.csv { send_data Team.to_csv(cohort: cohort) }
    end
  end

  def new
    !authenticate_user(true, true) && return
    @team = Team.new
    cohort = params[:cohort] || current_cohort
    @page_title = t('.page_title')
    render locals: {
      advisers: Adviser.where(cohort: cohort),
      mentors: Mentor.where(cohort: cohort),
      cohort: cohort
    }
  end

  def create
    !authenticate_user(true, true) && return
    @team = Team.new(team_params)
    cohort = @team.cohort || current_cohort
    if @team.save
      redirect_to teams_path(cohort: cohort), flash: {
        success: t('.success_message', team_name: @team.team_name)
      }
    else
      redirect_to new_team_path(cohort: cohort), flash: {
        danger: t('.failure_message',
                  error_message: @team.errors.full_messages.join(', '))
      }
    end
  end

  def show
    @team = Team.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       @team.get_relevant_users(true, true)) && return
    @page_title = t('.page_title', team_name: @team.team_name)
    cohort = @team.cohort || current_cohort
    render locals: {
      milestones: Milestone.where(cohort: cohort)
    }
  end

  def edit
    @team = Team.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       @team.get_relevant_users(false, false)) && return
    @page_title = t('.page_title', team_name: @team.team_name)
    cohort = @team.cohort || current_cohort
    render locals: {
      advisers: Adviser.where(cohort: cohort),
      mentors: Mentor.where(cohort: cohort)
    }
  end

  def update
    @team = Team.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       @team.get_relevant_users(false, false)) && return
    if @team.update(team_params)
      redirect_to team_path(@team.id), flash: {
        success: t('.success_message', team_name: @team.team_name)
      }
    else
      redirect_to edit_team_path(params[:id]), flash: {
        danger: t('.failure_message',
                  team_name: @team.team_name,
                  error_message: @team.errors.full_messages.join(', '))
      }
    end
  end

  def destroy
    !authenticate_user(true, true) && return
    @team = Team.find(params[:id])
    cohort = @team.cohort || current_cohort
    if @team.destroy
      redirect_to teams_path(cohort: cohort), flash: {
        success: t('.success_message', team_name: @team.team_name)
      }
    else
      redirect_to teams_path(cohort: cohort), flash: {
        danger: t('.failure_message', team_name: @team.team_name)
      }
    end
  end

  private

  def team_params
    team_ps = params.require(:team).permit(:team_name, :project_level,
                                           :adviser_id, :mentor_id,
                                           :has_dropped, :cohort)
    team_ps[:project_level] = Team.get_project_level_from_raw(
      team_ps[:project_level]) if team_ps[:project_level]
    team_ps
  end
end
