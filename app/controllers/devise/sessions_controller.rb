class Devise::SessionsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def new
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)
    reset_session

    render :text => user
  end

  def create
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)
    reset_session

    render :text => user
  end

  def destroy
    reset_session
    redirect_to root_url, :notice => 'Signed out!'
  end

  def failure
    redirect_to root_url, :alert => "Authentication error: #{params[:message].humanize}"
  end
end
