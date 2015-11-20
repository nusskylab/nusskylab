class TeamsController < ApplicationController
  def index
    not authenticate_user(true, false, Adviser.all.map {|adviser| adviser.user}) and return
    @teams = Team.order(:team_name).all
    @page_title = t('.page_title')
    respond_to do |format|
      format.html {render}
      format.csv {send_data Team.to_csv}
    end
  end

  def new
    not authenticate_user(true, true) and return
    @team = Team.new
    @page_title = t('.page_title')
    render locals: {advisers: Adviser.all, mentors: Mentor.all}
  end

  def create
    not authenticate_user(true, true) and return
    team_params = get_team_params
    @team = Team.new(team_params)
    @page_title = t('.page_title')
    if @team.save
      redirect_to teams_path, flash: {success: t('.success_message', team_name: @team.team_name)}
    else
      redirect_to new_team_path,
                  flash: {danger: t('.failure_message', error_messages: @team.errors.full_messages.join(', '))}
    end
  end

  def show
    @team = Team.find(params[:id]) or record_not_found
    not authenticate_user(true, false, @team.get_relevant_users(true, true)) and return
    @page_title = t('.page_title', team_name: @team.team_name)
    render locals: {
             milestones: Milestone.all
           }
  end

  def edit
    @team = Team.find(params[:id]) or record_not_found
    not authenticate_user(true, false, @team.get_relevant_users(false, false)) and return
    @page_title = t('.page_title', team_name: @team.team_name)
    render locals: {
             advisers: Adviser.all,
             mentors: Mentor.all
           }
  end

  def update
    @team = Team.find(params[:id]) or record_not_found
    not authenticate_user(true, false, @team.get_relevant_users(false, false)) and return
    if update_team
      redirect_to team_path(@team.id), flash: {success: t('.success_message', team_name: @team.team_name)}
    else
      redirect_to edit_team_path(params[:id]),
                  flash: {danger: t('.failure_message', team_name: @team.team_name,
                                    error_messages: @team.errors.full_messages.join(', '))}
    end
  end

  def destroy
    not authenticate_user(true, true) and return
    @team = Team.find(params[:id])
    if @team.destroy
      redirect_to teams_path, flash: {success: t('.success_message', team_name: @team.team_name)}
    else
      redirect_to teams_path, flash: {danger: t('.failure_message', team_name: @team.team_name)}
    end
  end

  private
  def update_team
    team_params = get_team_params
    @team.update(team_params) ? @team : nil
  end

  def get_team_params
    team_params = params.require(:team).permit(:team_name, :project_level,
                                               :adviser_id, :mentor_id, :has_dropped)
    team_params[:project_level] = Team.get_project_level_from_raw(team_params[:project_level]) if team_params[:project_level]
    team_params
  end
end
