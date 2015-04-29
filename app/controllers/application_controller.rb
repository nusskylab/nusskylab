class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def student?
    student ||= Student.student?(@current_user.id) if current_user
  end

  def adviser?
    adviser ||= Adviser.adviser?(@current_user.id) if current_user
  end

  def mentor?
    mentor ||= Mentor.mentor?(@current_user.id) if current_user
  end

  def admin?
    admin ||= Admin.admin?(@current_user.id) if current_user
  end

  helper_method 'current_user'
  helper_method 'student?'
  helper_method 'adviser?'
  helper_method 'mentor?'
  helper_method 'admin?'
end
