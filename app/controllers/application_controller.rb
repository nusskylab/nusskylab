# ApplicationController: base controller for Skylab
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include CohortHelper

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def authenticate_user(login_required = true, admin_only = false,
                        allowed_users = [], strategy = nil, **options)
    logged_in_user = current_user
    if !login_required
      return true
    elsif login_required && !logged_in_user
      redirect_user(options) and return false
    end
    if admin_only && !current_user_admin?
      redirect_user(options) and return false
    end
    return true if current_user_admin?
    unless allowed_users.index { |user| user.id == current_user.id }
      redirect_user(options) and return false
    end
    if !strategy.nil? && !strategy.call
      redirect_user(options) and return false
    end
    true
  end

  def redirect_user(options)
    redirect_path = options[:redirect_path] || home_path
    redirect_message = options[:redirect_message] ||
                       t('application.not_enough_privilege_message')
    redirect_to redirect_path, flash: { danger: redirect_message }
  end

  def after_sign_in_path_for(_resource)
    return root_path if current_user.nil?
    student = Student.student?(current_user.id, cohort: current_cohort)
    adviser = Adviser.adviser?(current_user.id, cohort: current_cohort)
    mentor = Mentor.mentor?(current_user.id, cohort: current_cohort)
    admin = Admin.admin?(current_user.id, cohort: current_cohort)
    if student && adviser.nil? && mentor.nil? &&
       admin.nil?
      main_app.student_path(student.id)
    elsif student.nil? && adviser && mentor.nil? && admin.nil?
      main_app.adviser_path(adviser.id)
    elsif student.nil? && adviser.nil? && mentor && admin.nil?
      main_app.mentor_path(mentor.id)
    elsif student.nil? && adviser.nil? && mentor.nil? && admin
      main_app.admin_path(admin.id)
    else
      main_app.user_path(current_user.id)
    end
  end

  def current_user_public?()
    return current_user.nil?
  end

  def current_user_student?(cohort = nil)
    cohort ||= current_cohort
    return unless current_user
    stu = Student.student?(current_user.id, cohort: cohort)
    stu if stu
  end

  def current_user_adviser?(cohort = nil)
    cohort ||= current_cohort
    Adviser.adviser?(current_user.id, cohort: cohort) if current_user
  end

  def current_user_mentor?(cohort = nil)
    cohort ||= current_cohort
    Mentor.mentor?(current_user.id, cohort: cohort) if current_user
  end

  def current_user_admin?(cohort = nil)
    cohort ||= current_cohort
    Admin.admin?(current_user.id, cohort: cohort) if current_user
  end

  def page_title
    @page_title ||= t('application.default_page_title')
  end

  def home_path
    current_user ? after_sign_in_path_for(current_user) : root_path
  end

  def forum_path
    "/forum"
  end

  def record_not_found
    respond_to do |f|
      f.html { render file: "#{Rails.root}/public/404.html", status: 404 }
    end
  end

  helper_method :home_path
  helper_method :forum_path
  helper_method :page_title
  helper_method :current_user_admin?
  helper_method :current_user_adviser?
  helper_method :current_user_mentor?
  helper_method :current_user_student?
  helper_method :current_user_public?
end
