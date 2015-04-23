class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def new
    redirect_to '/auth/NUS'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)
    reset_session
    session[:user_id] = user.id
    redirect_user(user)
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

  private
  def redirect_user(user)
    student = Student.student?(user.id)
    adviser = Adviser.adviser?(user.id)
    mentor = Mentor.mentor?(user.id)
    admin = Admin.admin?(user.id)
    if student and (not adviser) and (not mentor) and (not admin)
      redirect_to student_path(student.id)
    elsif (not student) and adviser and (not mentor) and (not admin)
      redirect_to adviser_path(adviser.id)
    elsif (not student) and (not adviser) and mentor and (not admin)
      redirect_to mentor_path(mentor.id)
    elsif (not student) and (not adviser) and (not mentor) and admin
      redirect_to admin_path(admin.id)
    else
      redirect_to user_path(user.id)
    end
  end
end
