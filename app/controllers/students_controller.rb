# StudentsController: manage actions related to students
#   index:   list of students
#   new:     view to create a student
#   create:  create a student
#   show:    view of a student
#   edit:    view to update a student
#   update:  update a student
#   destroy: delete a student
class StudentsController < ApplicationController
  def index
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    cohort = params[:cohort] || current_cohort
    @page_title = t('.page_title')
    @students = Student.where(cohort: cohort)
    respond_to do |format|
      format.html { render }
      format.csv { send_data Student.to_csv }
    end
  end

  def new
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    @student = Student.new
    render locals: {
      users: User.all.select { |user| !Student.student?(user.id) }
    }
  end

  def create
    !authenticate_user(true, true) && return
    user = User.find(params[:student][:user_id])
    if user
      if create_student_for_user(user)
        redirect_to students_path, flash: {
          success: t('.success_message', user_name: user.user_name)
        }
      else
        redirect_to new_student_path, flash: {
          danger: t('.failure_message',
                    error_message: @student.errors.full_messages.join(', '))
        }
      end
    else
      redirect_to new_student_path, flash: {
        danger: t('.user_missing_message')
      }
    end
  end

  def show
    @student = Student.find(params[:id])
    if @student.team_id.blank?
      relevant_users = [@student.user]
    else
      relevant_users = @student.team.get_relevant_users(false, false)
    end
    !authenticate_user(true, false, relevant_users) && return
    @page_title = t('.page_title', user_name: @student.user.user_name)
    return if !check_student_show_rendering
    render locals: {
      milestones: Milestone.order(:id).all,
      evaluateds: @student.team.evaluateds,
      evaluators: @student.team.evaluators,
      team_submissions: @student.team.get_own_submissions,
      team_evaluateds_submissions: @student.team.get_others_submissions,
      team_evaluations: @student.team.get_own_evaluations_for_others,
      team_evaluators_evaluations: @student.team.get_evaluations_for_own_team,
      team_feedbacks: @student.team.get_feedbacks_for_others
    }
  end

  def edit
    @student = Student.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@student.user]) && return
    @page_title = t('.page_title', user_name: @student.user.user_name)
    render locals: { teams: Team.all }
  end

  def update
    @student = Student.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@student.user]) && return
    if @student.update(student_params)
      redirect_to student_path(@student), flash: {
        success: t('.success_message', user_name: @student.user.user_name)
      }
    else
      redirect_to edit_student_path(@student), flash: {
        success: t('.failure_message',
                   error_message: @student.errors.full_messages.join(', '))
      }
    end
  end

  def destroy
    !authenticate_user(true, true) && return
    @student = Student.find(params[:id])
    redirect_after_destroy
  end

  private

  def student_params
    params.require(:student).permit(:team_id)
  end

  def create_student_for_user(user)
    @student = Student.new(user_id: user.id)
    @student.save ? @student : nil
  end

  def redirect_after_destroy
    if @student.destroy
      @student.team.destroy if @student.team.get_team_members.blank?
      redirect_to students_path, flash: {
        success: t('.success_message', user_name: @student.user.user_name)
      }
    else
      redirect_to students_path, flash: {
        danger: t('.failure_message', user_name: @student.user.user_name)
      }
    end
  end

  def check_student_show_rendering
    if @student.is_pending
      render template: 'students/show_pending'
      return false
    end
    if @student.team_id.blank?
      render template: 'students/show_no_team'
      return false
    end
    true
  end
end
