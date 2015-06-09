class TeamsController < ApplicationController
  layout 'general_layout'

  def index
    not check_access(true, true) and return
    @teams = Team.order(:team_name).all
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
    @team = Team.find(params[:id])
    display_team_access_control_strategy = lambda {
      loggedin_user = current_user
      if @team.adviser and @team.adviser.user_id == loggedin_user.id
        return true
      end
      if @team.mentor and @team.mentor.user_id == loggedin_user.id
        return true
      end
      students = @team.students
      is_student = false
      students.each do |student|
        if student.user_id == loggedin_user.id
          is_student = true
        end
      end
      if is_student
        return true
      end
      # TODO: to think about whether to allow evaluator/evaluated teams to view
      return false
    }
    not check_access(true, false, display_team_access_control_strategy) and return
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

  def get_home_link
    @team ? team_path(@team) : '/'
  end

  def get_page_title
    @page_title = @page_title || 'Teams | Orbital'
    super
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
      render layout: 'admins', template: 'teams/new', locals: {
                               advisers: Adviser.all,
                               mentors: Mentor.all
                             }
    end
end
