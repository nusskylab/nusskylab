class TeamsController < ApplicationController
  def index
    @teams = Team.all
  end

  def new
    @team = Team.new
    render locals: {
             advisers: Adviser.all,
             mentors: Mentor.all
           }
  end

  def create
    @team = create_or_update_team
    redirect_to teams_path
  end

  def show
    @team = Team.find(params[:id])
  end

  def edit
    @team = Team.find(params[:id])
    render locals: {
             advisers: Adviser.all,
             mentors: Mentor.all
           }
  end

  def update
    @team = create_or_update_team
    redirect_to @team
  end

  def destroy
    @team = Team.find(params[:id])
    @team.destroy
    redirect_to teams_path
  end

  private
  def create_or_update_team
    team_name = params[:team_name]
    project_title = params[:project_title]
    project_level = params[:project_level]
    adviser_id = params[:adviser_id]
    mentor_id = params[:mentor_id]
    Team.create_or_update_by_team_name(team_name: team_name,
                                       project_level: project_level,
                                       project_title: project_title,
                                       adviser_id: adviser_id,
                                       mentor_id: mentor_id)
  end
end
