class StudentsController < ApplicationController
  NUS_OPEN_ID_PREFIX = 'https://openid.nus.edu.sg/'
  NUS_OPEN_ID_PROVIDER = 'NUS'

  def index
    not authenticate_user(true, false, Adviser.all.map {|adviser| adviser.user}) and return
    @page_title = t('.page_title')
    @students = Student.all
  end

  def new
    not authenticate_user(true, true) and return
    @page_title = t('.page_title')
    @student = Student.new
    render locals: {users: User.all.filter {|user| not Student.student?(user.id)}}
  end

  def create
    not authenticate_user(true, true) and return
    user = User.find(params[:student][:user_id])
    if user
      if create_student_for_user(user)
        redirect_to students_path, flash: {success: t('.success_message', user_name: user.user_name)}
      else
        redirect_to new_student_path,
                    flash: {danger: t('.failure_message',
                                      error_messages: @student.errors.full_messages.join(', '))}
      end
    else
      redirect_to new_student_path, flash: {danger: t('.user_missing_message')}
    end
  end

  def edit
    @student = Student.find(params[:id])
    not authenticate_user(true, false, [@student.user] ) and return
    @page_title = t('.page_title', user_name: @student.user.user_name)
    render locals: {teams: Team.all}
  end

  def update
    @student = Student.find(params[:id])
    not authenticate_user(true, false, [@student.user] ) and return
    student_params = params.require(:student).permit(:team_id)
    if @student.update(student_params)
      redirect_to student_path(@student),
                  flash: {success: t('.success_message', user_name: @student.user.user_name)}
    else
      redirect_to edit_student_path(@student),
                  flash: {success: t('failure_message', error_messages: @student.errors.full_messages.join(', '))}
    end
  end

  def show
    @student = Student.find(params[:id])
    if @student.team_id.blank?
      relevant_users = [@student.user]
    else
      relevant_users = @student.team.get_relevant_users(false, false)
    end
    not authenticate_user(true, false, relevant_users) and return
    @page_title = t('.page_title', user_name: @student.user.user_name)
    if @student.team_id.blank?
      render template: 'students/show_no_team' and return
    end
    render locals: {
             milestones: Milestone.all,
             evaluateds: @student.team.evaluateds,
             evaluators: @student.team.evaluators,
             team_submissions: @student.team.get_own_submissions,
             team_evaluateds_submissions: @student.team.get_others_submissions,
             team_evaluations: @student.team.get_own_evaluations_for_others,
             team_evaluators_evaluations: @student.team.get_evaluations_for_own_team,
             team_feedbacks: @student.team.get_feedbacks_for_others
           }
  end

  def destroy
    not authenticate_user(true, true) and return
    @student = Student.find(params[:id])
    if @student.destroy
      redirect_to students_path, flash: {success: t('.success_message', user_name: @student.user.user_name)}
    else
      redirect_to students_path, flash: {danger: t('.failure_message', user_name: @student.user.user_name)}
    end
  end

  private
  def create_student_for_user(user)
    @student = Student.new(user_id: user.id)
    @student.save ? @student : nil
  end
end
