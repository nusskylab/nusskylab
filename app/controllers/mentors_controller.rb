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
    {
      milestones: milestones,
      teams_submissions: teams_submissions
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

  # Returns params needed for batch creation of roles
  def batch_role_params
    params.permit(users: [:user_id, :cohort, :slide_link])
  end
end
