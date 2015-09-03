class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # Used for checking access. allowed_users is an array of users that can access and options
  #   is a hash for specify additional information such as redirect_path and redirect_message
  def authenticate_user(login_required = true, admin_only = false, allowed_users = [], **options)
    logged_in_user = current_user
    if login_required and not logged_in_user
      redirect_user(options) and return false
    end
    if admin_only and not is_current_user_admin?
      redirect_user(options) and return false
    end
    if not is_current_user_contained?(allowed_users)
      redirect_user(options) and return false
    end
    true
  end

  def is_current_user_contained?(users = [])
    users.each do |user|
      if user.id == current_user.id
        return true
      end
    end
    false
  end

  def redirect_user(options)
    redirect_path = options[:redirect_path] || get_home_link
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
      if not is_current_user_admin?
        redirect_user({}) and return false
      end
    end
    if is_current_user_admin?
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
      student_path(student.id)
    elsif (not student) and adviser and (not mentor) and (not admin)
      adviser_path(adviser.id)
    elsif (not student) and (not adviser) and mentor and (not admin)
      mentor_path(mentor.id)
    elsif (not student) and (not adviser) and (not mentor) and admin
      admin_path(admin.id)
    else
      user_path(logged_in_user.id)
    end
  end

  def is_current_user_student?
    Student.student?(current_user.id) if current_user
  end

  def is_current_user_adviser?
    Adviser.adviser?(current_user.id) if current_user
  end

  def is_current_user_mentor?
    Mentor.mentor?(current_user.id) if current_user
  end

  def is_current_user_admin?
    Admin.admin?(current_user.id) if current_user
  end

  def get_page_title
    @page_title = @page_title || 'Orbital'
  end

  def get_home_link
    current_user ? after_sign_in_path_for(current_user) : '/'
  end

  def record_not_found
    respond_to do |f|
      f.html {render file: "#{Rails.root}/public/404.html", status: 404}
    end
  end

  helper_method :get_home_link
  helper_method :get_page_title
  helper_method :is_current_user_admin?
  helper_method :is_current_user_adviser?
  helper_method :is_current_user_mentor?
  helper_method :is_current_user_student?
end
