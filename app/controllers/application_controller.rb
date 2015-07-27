class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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
    student ||= Student.student?(current_user.id) if current_user
  end

  def adviser?
    adviser ||= Adviser.adviser?(current_user.id) if current_user
  end

  def mentor?
    mentor ||= Mentor.mentor?(current_user.id) if current_user
  end

  def admin?
    admin ||= Admin.admin?(current_user.id) if current_user
  end

  def check_access(login_required = true, admin_only = false, special_access_strategy = nil)
    if login_required
      if not current_user
        does_not_have_access and return false
      end
    end
    if admin_only
      if not admin?
        does_not_have_access and return false
      end
    end
    if admin?
      return true
    end
    if special_access_strategy.nil?
      return true
    else
      if not (special_access_strategy.call())
        does_not_have_access and return false
      else
        return true
      end
    end
  end

  def does_not_have_access
    flash = {}
    flash[:danger] = 'You are not allowed to do this, please contact admin for more information'
    redirect_to root_url, flash: flash
  end

  def get_home_link
    current_user ? after_sign_in_path_for(current_user) : '/'
  end

  def after_sign_in_path_for(resource)
    user = current_user
    if user.nil?
      return '/'
    end
    student = Student.student?(user.id)
    adviser = Adviser.adviser?(user.id)
    mentor = Mentor.mentor?(user.id)
    admin = Admin.admin?(user.id)
    if student and (not adviser) and (not mentor) and (not admin)
      return student_path(student.id)
    elsif (not student) and adviser and (not mentor) and (not admin)
      return adviser_path(adviser.id)
    elsif (not student) and (not adviser) and mentor and (not admin)
      return mentor_path(mentor.id)
    elsif (not student) and (not adviser) and (not mentor) and admin
      return admin_path(admin.id)
    else
      return user_path(user.id)
    end
  end

  def get_page_title
    @page_title = @page_title || 'Orbital'
    return @page_title
  end

  def record_not_found
    flash = {}
    flash[:warning] = 'The object you tried to access does not exist'
    redirect_to get_home_link, flash: flash
  end

  helper_method 'current_user'
  helper_method 'get_current_role'
  helper_method 'student?'
  helper_method 'adviser?'
  helper_method 'mentor?'
  helper_method 'admin?'
  helper_method 'get_home_link'
  helper_method 'get_page_title'
end
