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

  # Used for checking access. allowed_users is an array of users that can access and options
  #   is a hash for specify additional information such as redirect_path and redirect_message
  def authenticate_user(login_required = true, admin_only = false, allowed_users, **options)
    logged_in_user = current_user
    if login_required and not logged_in_user
      redirect_user(options) and return false
    end
    is_user_admin = Admin.admin?(logged_in_user.id)
    if admin_only and not is_user_admin
      redirect_user(options) and return false
    end
    is_user_allowed = is_user_admin
    allowed_users.each do |allowed_user|
      if allowed_user.id == logged_in_user.id
        is_user_allowed = true
      end
    end
    if not is_user_allowed
      redirect_user(options) and return false
    else
      return true
    end
  end

  def redirect_user(options)
    redirect_path = options[:redirect_path] || root_path
    redirect_message = options[:redirect_message] || t('application.not_enough_privilege_message')
    redirect_to redirect_path, flash: {danger: redirect_message}
  end

  # TODO: remove this method later if confirmed not in use
  # Deprecated, used for check_access
  def check_access(login_required = true, admin_only = false, special_access_strategy = nil)
    if login_required
      if not current_user
        redirect_user({}) and return false
      end
    end
    if admin_only
      if not admin?
        redirect_user({}) and return false
      end
    end
    if admin?
      return true
    end
    if special_access_strategy.nil?
      return true
    else
      if not (special_access_strategy.call())
        redirect_user({}) and return false
      else
        return true
      end
    end
  end

  def get_home_link
    current_user ? after_sign_in_path_for(current_user) : '/'
  end

  def after_sign_in_path_for(resource)
    logged_in_user = current_user
    if logged_in_user.nil?
      return '/'
    end
    student = Student.student?(logged_in_user.id)
    adviser = Adviser.adviser?(logged_in_user.id)
    mentor = Mentor.mentor?(logged_in_user.id)
    admin = Admin.admin?(logged_in_user.id)
    if student and (not adviser) and (not mentor) and (not admin)
      return student_path(student.id)
    elsif (not student) and adviser and (not mentor) and (not admin)
      return adviser_path(adviser.id)
    elsif (not student) and (not adviser) and mentor and (not admin)
      return mentor_path(mentor.id)
    elsif (not student) and (not adviser) and (not mentor) and admin
      return admin_path(admin.id)
    else
      return user_path(logged_in_user.id)
    end
  end

  def get_page_title
    @page_title = @page_title || 'Orbital'
    return @page_title
  end

  def record_not_found
    respond_to do |f|
      f.html{ render file: "#{Rails.root}/public/404.html", status: 404 }
    end
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
