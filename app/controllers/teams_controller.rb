# TeamsController: manage actions related to team
#   index:   list of teams
#   new:     view to create a team
#   create:  create a team
#   show:    view of a team
#   edit:    view to update a team
#   destroy: delete a team
class TeamsController < ApplicationController
  def index
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    cohort = params[:cohort] || current_cohort
    @teams = Team.order(:team_name).where(cohort: cohort)
    @page_title = t('.page_title')
    respond_to do |format|
      format.html { render }
      format.csv { send_data Team.to_csv }
    end
  end

  def new
    !authenticate_user(true, true) && return
    @team = Team.new
    @page_title = t('.page_title')
    render locals: {
      advisers: Adviser.all,
      mentors: Mentor.all
    }
  end

  def create
    !authenticate_user(true, true) && return
    @team = Team.new(team_params)
    @page_title = t('.page_title')
    if @team.save
      redirect_to teams_path, flash: {
        success: t('.success_message', team_name: @team.team_name)
      }
    else
      redirect_to new_team_path, flash: {
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
    render locals: {
      milestones: Milestone.all
    }
  end

  def edit
    @team = Team.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       @team.get_relevant_users(false, false)) && return
    @page_title = t('.page_title', team_name: @team.team_name)
    render locals: {
      advisers: Adviser.all,
      mentors: Mentor.all
    }
  end

  def update
    @team = Team.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false,
                       @team.get_relevant_users(false, false)) && return
    if update_team
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
    if @team.destroy
      redirect_to teams_path, flash: {
        success: t('.success_message', team_name: @team.team_name)
      }
    else
      redirect_to teams_path, flash: {
        danger: t('.failure_message', team_name: @team.team_name)
      }
    end
  end

  private

  def update_team
    @team.update(team_params) ? @team : nil
  end

  def team_params
    team_ps = params.require(:team).permit(:team_name, :project_level,
                                           :adviser_id, :mentor_id,
                                           :has_dropped)
    team_ps[:project_level] = Team.get_project_level_from_raw(
      team_ps[:project_level]) if team_ps[:project_level]
    team_ps
  end
end
