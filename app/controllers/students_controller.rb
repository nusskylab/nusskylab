class StudentsController < ApplicationController
  def index
    @students = Student.all
  end

  def create
    @student = create_student_user
    redirect_to students_path
  end

  def new
    @student = Student.new
  end

  def edit
    @student = Student.find(params[:id])
  end

  def show
    @student = Student.find(params[:id])
  end

  def update
    redirect_to students_path
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to students_path
  end

  private
  def create_student_user
    uid = 'https://openid.nus.edu.sg/' + params[:matric_num]
    provider = 'NUS'
    email = params[:user_email]
    user_name = params[:user_name]
    user = User.create_or_silent_failure(uid: uid, provider: provider, email: email, user_name: user_name)
    team_name = params[:team_name]
    project_title = params[:project_title]
    team = Team.create_or_silent_failure(team_name: team_name, project_title: project_title)
    team.save
    @student = Student.create_or_silent_failure(user_id: user.id, team_id: team.id)
    @student.save()
    return @student
  end
end
