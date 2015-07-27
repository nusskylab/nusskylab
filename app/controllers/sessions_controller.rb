class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def new
    redirect_to '/auth/NUS'
  end

  def create
    auth = request.env["omniauth.auth"]
    user = User.from_omniauth(auth)
    sign_in(user)
    redirect_user
  end

  def destroy
    sign_out(user)
    flash = {}
    flash[:info] = 'You have signed out!'
    redirect_to root_url, flash: flash
  end

  def failure
    flash = {}
    flash[:danger] = "Authentication error: #{params[:message].humanize}"
    redirect_to root_url, flash: flash
  end

  private
    def redirect_user
      user = current_user
      flash = {}
      flash[:success] = "Welcome, #{user.user_name}"
      redirect_to after_sign_in_path_for('NUS'), flash: flash
    end
end
