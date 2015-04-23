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
    render locals: {
             batch_csv: ''
           }
  end

  def edit
    @student = Student.find(params[:id])
  end

  def show
    @student = Student.find(params[:id])
    milestones = Milestone.all
    team_submissions_table = {}
    if @student.team_id
      submissions = @student.team.submissions
      milestones.each do |milestone|
        submissions.each do |submission|
          if milestone.id.to_i == submission.id.to_i
            team_submissions_table[milestone.id.to_i] = submission
          end
        end
      end
    end
    render locals: {
             milestones: milestones,
             team_submissions_table: team_submissions_table
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
    if params[:batch_creation]
      require 'csv'
      batch_csv = params[:batch_csv]
      CSV.foreach(batch_csv, {col_sep: "\t", headers: true}) do |row|
        puts row
      end
    else
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
    end
    return student
  end
end
