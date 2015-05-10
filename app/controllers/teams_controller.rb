class TeamsController < ApplicationController
  layout 'general_layout'

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
    @team = Team.new(get_team_params)
    if @team.save
      redirect_to teams_path
    else
      render 'new', locals: {
                    advisers: Adviser.all,
                    mentors: Mentor.all
                  }
    end
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
    team = update_team
    if team
      redirect_to @team
    else
      render 'edit', locals: {
                     advisers: Adviser.all,
                     mentors: Mentor.all
                   }
    end
  end

  def destroy
    @team = Team.find(params[:id])
    if @team.destroy
      flash = {}
      flash[:info] = 'The team is deleted successfully'
      redirect_to teams_path, flash: flash
    end
  end

  private
  def update_team
    @team = Team.find(params[:id])
    team_params = get_team_params
    @team.update(team_params) ? @team : nil
  end

  def get_team_params
    team_params = params.require(:team).permit(:team_name, :project_level,
                                               :adviser_id, :mentor_id)
  end
end
