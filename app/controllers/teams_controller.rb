class TeamsController < ApplicationController
  layout 'general_layout'

  def index
    not check_access(true, true) and return
    @teams = Team.all
    render layout: 'admins'
  end

  def new
    not check_access(true, true) and return
    @team = Team.new
    render layout: 'admins', locals: {
                             advisers: Adviser.all,
                             mentors: Mentor.all
                           }
  end

  def create
    not check_access(true, true) and return
    @team = Team.new(get_team_params)
    if @team.save
      redirect_to teams_path
    else
      render_new_template
    end
  end

  def show
    not check_access(true, false) and return
    @team = Team.find(params[:id])
  end

  def edit
    not check_access(true, false) and return
    @team = Team.find(params[:id])
    render locals: {
             advisers: Adviser.all,
             mentors: Mentor.all
           }
  end

  def update
    not check_access(true, false) and return
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
    not check_access(true, true) and return
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

    def render_new_template
      render layout: 'admins', template: 'new', locals: {
                               advisers: Adviser.all,
                               mentors: Mentor.all
                             }
    end
end
