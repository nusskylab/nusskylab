# StudentsController
class StudentsController < RolesController
  def role_cls
    Student
  end

  def role_params
    stu = params.require(:student).permit(
      :user_id, :team_id, :application_status, :cohort, :evaluator_ids, :evaluatee_ids
    )
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

  def submit_proposal
    @user = User.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@user]) && return
    student = Student.student?(@user.id, cohort: current_cohort)
    return redirect_to user_path(@user.id), flash: {
      danger: 'Invalid action.'
    } unless student
    student_team = student.team
    render locals: {
      student_team: student_team
    }
  end

  def upload_proposal
    @user = User.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@user]) && return
    student = Student.student?(@user.id, cohort: current_cohort)
    return redirect_to user_path(@user.id), flash: {
      danger: 'Invalid action.'
    } unless student
    team_id = student.team.id
    team = student.team
    team_params = params.require(:team).permit(:proposal_link)
    team.proposal_link = team_params[:proposal_link]
    team.application_status = 'c'
    success = team.save!
    if success
      redirect_to user_path(@user.id), flash: {
        success: 'Proposal link submitted successfully. Please proceed to check your submitted proposal.'
      }
    else
      redirect_to user_path(@user.id), flash: {
        danger: 'Submission failed.'
      }
    end
  end

  def withdraw_invitation
    @user = User.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@user]) && return
    student = Student.student?(@user.id, cohort: current_cohort)
    student_team = student.team
    render locals: {
      student_team: student_team
    }
  end

  def confirm_withdraw
    @user = User.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@user]) && return
    team_params = params.require(:team).permit(:withdraw)
    student_user = Student.find_by(user_id: @user.id, cohort: current_cohort)
    return redirect_to user_path(@user.id), flash: {
      danger: 'Invalid action.'
    } if !student_user || !student_user.team
    team = student_user.team
    if team_params[:withdraw] == 'false'
      flash_message = 'Withdrawl cancalled.'
      redirect_to user_path(@user.id), flash: {
        warning: flash_message
      }
    else
      team.destroy
      flash_message = 'Success.'
      redirect_to user_path(@user.id), flash: {
        success: flash_message
      }
    end
  end
    

  def remove_proposal
    @user = User.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@user]) && return
    student = Student.student?(@user.id, cohort: current_cohort)
    student.team.application_status = 'b'
    student.team.save
    render locals: {
      student_team: student.team
    }
  end

  def confirm_remove_proposal
    @user = User.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@user]) && return
    team_params = params.require(:team).permit(:remove_link)
    student_user = Student.student?(@user.id, cohort: current_cohort)
    return redirect_to user_path(@user.id), flash: {
      warning: "Cannot withdraw invitation"
    } if !student_user || !student_user.team
    team = student_user.team
    if team_params[:remove_link] == 'false'
      flash_message = "Removal of proposal cancelled."
      redirect_to user_path(@user.id), flash: {
        warning: flash_message
      }
    else
      team.update_attribute(:proposal_link, nil)
      flash_message = "Removal of proposal successful."
      redirect_to user_path(@user.id), flash: {
        success: flash_message
      }
    end
  end

  def do_evaluation
    @user = User.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@user]) && return
    student = Student.student?(@user.id, cohort: current_cohort)
    evaluatee_links = []
    evaluatee_ids = student.evaluatee_ids
    evaluatee_ids.each do |id|
      evaluatee = Team.find_by(id: id)
      evaluatee_link = evaluatee.proposal_link
      evaluatee_links << evaluatee_link
    end
    render locals:{
      links: evaluatee_links
    }
  end
end
