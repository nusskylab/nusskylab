class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def get_current_role
    if not current_user
      return 'As a visitor'
    end
    if admin?
      return 'As an admin'
    elsif student?
      return 'As a student'
    elsif adviser?
      return 'As an adviser'
    elsif mentor?
      return 'As a mentor'
    else
      return 'As a visitor'
    end
  end

  def get_layout_for_role
    if admin?
      'admins'
    else
      'general_layout'
    end
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

  def does_not_have_access
    flash = {}
    flash[:danger] = 'You do not have privilege to do this'
    redirect_to root_url, flash: flash
  end

  helper_method 'current_user'
  helper_method 'get_current_role'
  helper_method 'student?'
  helper_method 'adviser?'
  helper_method 'mentor?'
  helper_method 'admin?'
end
