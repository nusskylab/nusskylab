class StudentsController < ApplicationController
  NUS_OPEN_ID_PREFIX = 'https://openid.nus.edu.sg/'
  NUS_OPEN_ID_PROVIDER = 'NUS'

  def index
    @students = Student.all
  end

  def create
    create_or_update_student_user
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
    render locals: {
             milestones: Milestone.all
           }
  end

  def update
    create_or_update_student_user
    redirect_to students_path
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to students_path
  end

  private
  def create_or_update_student_user
    uid = NUS_OPEN_ID_PREFIX + params[:nus_id]
    provider = NUS_OPEN_ID_PROVIDER
    email = params[:user_email]
    user_name = params[:user_name]
    user = User.create_or_update_by_provider_and_uid(uid: uid,
                                                     provider: provider,
                                                     email: email,
                                                     user_name: user_name)
    team_name = params[:team_name]
    project_title = params[:project_title]
    project_level = params[:project_level]
    student = Student.create_or_update_by_user_id(user_id: user.id,
                                                  team_name: team_name,
                                                  project_title: project_title,
                                                  project_level: project_level)
    return student
  end
end
