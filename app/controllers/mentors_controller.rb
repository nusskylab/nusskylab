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

  def path_for_new_batch(ps ={})
    new_batch_mentors_path(ps)
  end

  def path_for_show(role_id)
    mentor_path(role_id)
  end

  def create_batch
    !authenticate_user(true, false, additional_users_for_new) && return
    post_params = batch_role_params
    cohort = post_params[:users][0][:cohort]
    mentor_params = post_params[:users]

    # Remove duplicates, retaining the last duplicated item.
    mentor_params = mentor_params.reverse.uniq{|u| u[:user_id]}.reverse
    mentors = Mentor.create(mentor_params)

    if mentors.all? { |mentor| mentor.persisted? }
      redirect_to path_for_index(cohort: cohort), flash: {
        success: t('.success_message', user_count: mentor_params.count)
      }
    else
      success_count = mentors.select{|m| m.persisted?}.count
      errors = mentors.map { |mentor| mentor.errors.full_messages.empty? ? nil
        : t('.specific_failure_message', user_name: User.find(mentor.user_id).user_name,
            error_message: mentor.errors.full_messages.join('. '))}.compact.join('')

      redirect_to path_for_new_batch(cohort: cohort), flash: {
        danger: t('.failure_message', success_count: success_count, error_messages: errors)
      }
    end
  end

  def data_for_role_show
    @mentor = Mentor.find(params[:id]) || (record_not_found && return)
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
    teamsMentorMatchings = MentorMatching.where(:mentor_id => @mentor.id).order(:choice_ranking);
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
    !authenticate_user(true, false, [@mentor.user]) && return
    cohort = @mentor.cohort || current_cohort
    team = Team.find(params[:team])
    puts "Team #{team.team_name}"

    acceptedMentorMatchings = MentorMatching.find_by(:team_id => team.id, :mentor_id => @mentor.id)
    if ((MentorMatching.update(acceptedMentorMatchings.id, :mentor_accepted => true)) && (!acceptedMentorMatchings.mentor_accepted))
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

  # Returns params needed for batch creation of roles
  def batch_role_params
    params.permit(users: [:user_id, :cohort, :slide_link])
  end
end
