# StudentsController
class StudentsController < RolesController
  def role_cls
    Student
  end

  def role_params
    stu = params.require(:student).permit(
      :user_id, :team_id, :application_status, :cohort
    )
    #stu.delete(:application_status) unless stu[:application_status] && @role.application_status
    stu
  end

  def path_for_index(ps = {})
    students_path(ps)
  end

  def path_for_new(ps = {})
    new_student_path(ps)
  end

  def path_for_new_batch(ps ={})
    new_batch_students_path(ps)
  end

  def path_for_edit(role_id)
    edit_student_path(role_id)
  end

  def path_for_show(role_id)
    student_path(role_id)
  end

  def data_for_role_show
    milestones = Milestone.order(:id).where(cohort: @role.cohort)
    survey_templates = []
    milestones.each do |milestone|
      survey_templates = survey_templates.concat(milestone.survey_templates)
    end
    basic_data = {
      milestones: milestones,
      survey_templates: survey_templates
    }
    basic_data.merge(team_related_data_for_student)
  end

  def team_related_data_for_student
    return {} if @role.team_id.blank?
    {
      evaluateds: @role.team.evaluateds,
      evaluators: @role.team.evaluators,
      team_submissions: @role.team.get_own_submissions,
      team_evaluateds_submissions: @role.team.get_others_submissions,
      team_evaluations: @role.team.get_own_evaluations_for_others,
      team_evaluators_evaluations: @role.team.get_evaluations_for_own_team,
      team_feedbacks: @role.team.get_feedbacks_for_others,
      adviser_feedbacks: @role.team.get_feedbacks_for_adviser
    }
  end

  def data_for_role_edit
    { teams: Team.where(cohort: @role.cohort) }
  end

  def handles_for_actions
    success_cb = lambda do
      @role.team.destroy if @role.team_id && @role.team.get_team_members.blank?
    end
    {
      destroy: {
        success: success_cb
      }
    }
  end

  def additional_users_for_index
    cohort = params[:cohort] || current_cohort
    Adviser.where(cohort: cohort).map(&:user)
  end

  def additional_users_for_show
    if @role.team_id.blank?
      relevant_users = [@role.user]
    else
      relevant_users = @role.team.get_relevant_users(false, false)
    end
    relevant_users
  end

  def get_proposal_link
    proposal_link = proposal_link_params[:proposal_link]

  def proposal_link_params
    params.require(:team).permit(:proposal_link)
  end

  #helper_method :get_proposal_link
end
