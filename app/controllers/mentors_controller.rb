# MentorsController
class MentorsController < RolesController
  def role_cls
    Mentor
  end

  def role_params
    params.require(:mentor).permit(:user_id, :cohort)
  end

  def path_for_index(ps = {})
    mentors_path(ps)
  end

  def path_for_new(ps = {})
    new_mentor_path(ps)
  end

  def path_for_edit(role_id)
    edit_mentor_path(role_id)
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
    role_data = {}
    role_data[:milestones] = milestones
    role_data[:teams_submissions] = teams_submissions
    role_data
  end
end
