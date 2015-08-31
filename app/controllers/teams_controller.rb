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
    team_params = get_team_params
    @team = Team.new(team_params)
    if @team.save
      redirect_to teams_path, flash: {success: t('.success_message')}
    else
      redirect_to new_team_path,
                  flash: {success: t('.failure_message' + @team.errors.full_messages.join(', '))}
    end
  end

  def show
    @team = Team.find(params[:id])
    display_team_access_control_strategy = lambda {
      can_access_team_page = false
      loggedin_user = current_user
      relevant_users = @team.get_relevant_users(true, true)
      relevant_users.each do |user|
        if user.id == loggedin_user.id
          can_access_team_page = true and break
        end
      end
      return can_access_team_page
    }
    not check_access(true, false, display_team_access_control_strategy) and return
    ratings_hash = @team.get_average_rating_for_self_team_as_hash
    render locals: {
             milestones: Milestone.all,
             ratings_hash: ratings_hash
           }
  end

  def edit
    @team = Team.find(params[:id])
    edit_team_access_controll_strategy = lambda {
      can_access_team_page = false
      loggedin_user = current_user
      relevant_users = @team.get_relevant_users
      relevant_users.each do |user|
        if user.id == loggedin_user.id
          can_access_team_page = true and break
        end
      end
      return can_access_team_page
    }
    not check_access(true, false, edit_team_access_controll_strategy) and return
    render locals: {
             advisers: Adviser.all,
             mentors: Mentor.all
           }
  end

  def update
    @team = Team.find(params[:id])
    update_team_access_controll_strategy = lambda {
      can_access_team_page = false
      loggedin_user = current_user
      relevant_users = @team.get_relevant_users
      relevant_users.each do |user|
        if user.id == loggedin_user.id
          can_access_team_page = true and break
        end
      end
      return can_access_team_page
    }
    not check_access(true, false, update_team_access_controll_strategy) and return
    if update_team
      redirect_to team_path(@team.id), flash: {success: t('.success_message')}
    else
      redirect_to edit_team_path(params[:id]),
                  flash: {success: t('.failure_message' + @team.errors.full_messages.join(', '))}
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

  def get_page_title
    @page_title = @page_title || 'Teams | Orbital'
    super
  end

  private
  def update_team
    team_params = get_team_params
    @team.update(team_params) ? @team : nil
  end

  def get_team_params
    team_params = params.require(:team).permit(:team_name, :project_level,
                                               :adviser_id, :mentor_id, :has_dropped)
    team_params[:project_level] = Team.get_project_level_mapping_from_raw(team_params[:project_level])
    team_params
  end
end
