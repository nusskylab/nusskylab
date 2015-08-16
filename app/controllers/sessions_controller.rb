class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def new
    redirect_to '/auth/NUS'
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)
    if user
      sign_in(user)
      redirect_user_after_sign_in
    else
      redirect_user_after_sign_in(false)
    end
  end

  def destroy
    sign_out(current_user)
    redirect_to root_url, flash: {info: t('sessions.sign_out_success_message')}
  end

  def failure
    redirect_to root_url, flash: {danger: t('sessions.sign_in_authentication_error_message',
                                            auth_error: params[:message].humanize)}
  end

  private
  def redirect_user_after_sign_in(success = true)
    if success
      user = current_user
      redirect_to after_sign_in_path_for('NUS'), flash: {success: t('sessions.sign_in_success_message',
                                                                    user_name: user.user_name)}
    else
      redirect_to root_path, flash: {danger: t('sessions.sign_in_failure_message')}
    end
  end
end
