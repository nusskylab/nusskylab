class SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create
  def create
    auth = request.env["omniauth.auth"]
    user_info = _extract_user_info(auth)
    render :text => user_info
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end

  private
    def _extract_user_info(auth)
      if auth.provider == 'NUS'
        user_info = {'provider' => auth.provider, 'uid' => auth.uid,
                     'email'=> auth.info.email, 'user_name' => auth.info.name,
                     'nickname' => auth.info.nickname}
        return user_info
      else
        return nil
      end
    end
end
