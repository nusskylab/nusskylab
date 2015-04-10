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
    if s = Student.is_a_student(user.id)
      redirect_to s
    elsif a = Adviser.is_an_adviser(user.id)
      redirect_to a
    elsif m = Mentor.is_a_mentor(user.id)
      redirect_to m
    else
      redirect_to user
    end
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
