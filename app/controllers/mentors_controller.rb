# MentorsController
class MentorsController < RolesController
  def role_cls
    Mentor
  end

  def role_params
    params.require(:mentor).permit(:user_id, :cohort, :slide_link)
  end

  def path_for_index(ps = {})
    mentors_path(ps)
  end

  def path_for_new(ps = {})
    new_mentor_path(ps)
  end

  def path_for_show(role_id)
    mentor_path(role_id)
  end

  def data_for_role_show
    milestones = Milestone.order(:id).where(cohort: @role.cohort)
    teams_submissions = {}
    milestones.each do |milestone|
      teams_submissions[milestone.id] = {}
      @role.teams.each do |team|
        teams_submissions[milestone.id][team.id] = Submission.find_by(
          milestone_id: milestone.id,
          team_id: team.id
        )
      end
    end
    teamsMentorMatchings = MentorMatchings.where(:mentor_id => params[:id]).order(:choice_ranking);
    {
      milestones: milestones,
      teams_submissions: teams_submissions,
      teamsMentorMatchings: teamsMentorMatchings
    }
  end

  def data_for_role_edit
    {
      users: User.all(),
      cohort: params[:cohort] || current_cohort
    }
  end

  def data_for_role_general_mailing
    users = []
    @role.teams.each do |team|
      users.concat(team.get_team_members)
    end
    {
      users: users
    }
  end

  def accept_team 
    @mentor = Mentor.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@mentor]) && return
    cohort = @mentor.cohort || current_cohort
    team = Team.find(params[:team])
    puts "Team #{team.team_name}"
    acceptedMentorMatchings = MentorMatchings.find_by(:team_id => team.id, :mentor_id => @mentor.id)
    if MentorMatchings.update(acceptedMentorMatchings.id, :mentor_accepted => true)
      redirect_to mentor_path(@mentor.id), flash: {
        success: t('.success_message', team_name: team.team_name)
      }
      return
    else
      redirect_to mentor_path(@mentor.id), flash: {
        danger: t('.failure_message', team_name: team.team_name)
      }
      return
    end
  end
end
