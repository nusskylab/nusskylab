# AdvisersController
class AdvisersController < RolesController
  def role_cls
    Adviser
  end

  def role_params
    params.require(:adviser).permit(:user_id, :cohort)
  end

  def path_for_index(ps = {})
    advisers_path(ps)
  end

  def path_for_new(ps = {})
    new_adviser_path(ps)
  end

  def path_for_show(role_id)
    adviser_path(role_id)
  end

  def data_for_role_show
    milestones = Milestone.order(:id).where(cohort: @role.cohort)
    teams_submissions = {}
    own_evaluations = {}
    populate_adviser_data(milestones, teams_submissions, own_evaluations)
    {
      milestones: milestones,
      teams_submissions: teams_submissions,
      own_evaluations: own_evaluations
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

  def populate_adviser_data(milestones, teams_submissions, own_evaluations)
    milestones.each do |milestone|
      teams_submissions[milestone.id] = {}
      own_evaluations[milestone.id] = {}
      @role.teams.each do |team|
        team_sub = Submission.find_by(
          milestone_id: milestone.id,
          team_id: team.id
        )
        teams_submissions[milestone.id][team.id] = team_sub
        next if team_sub.nil?
        own_evaluations[milestone.id][team.id] =
          PeerEvaluation.find_by(
            submission_id: team_sub.id,
            adviser_id: @role.id
          )
      end
    end
  end
end
