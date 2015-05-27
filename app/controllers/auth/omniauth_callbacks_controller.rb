class Auth::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token, :only => :create

  def open_id
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)
    reset_session
    session[:user_id] = user.id
    redirect_user(user)
  end

  # GET|POST /resource/auth/twitter
  def passthru
    redirect_to 'https://openid.nus.edu.sg/auth'
  end

  # GET|POST /users/auth/twitter/callback
  def failure
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)
    reset_session
    session[:user_id] = user.id
    redirect_user(user)
  end

  # protected

  # The path used when omniauth fails
  def after_omniauth_failure_path_for(scope)
    flash = {}
    flash[:danger] = "Authentication error: #{params[:message].humanize}"
    redirect_to root_url, flash: flash
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
    flash = {}
    flash[:info] = 'You have signed out!'
    redirect_to root_url, flash: flash
  end

  private
  def redirect_user(user)
    flash = {}
    flash[:success] = "Welcome, #{user.user_name}"
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
      redirect_to user_path(user.id), flash: flash
    end
  end
end
