class AdvisersController < ApplicationController
  NUS_OPEN_ID_PREFIX = 'https://openid.nus.edu.sg/'
  NUS_OPEN_ID_PROVIDER = 'NUS'

  def index
    @advisers = Adviser.all
  end

  def new
    @adviser = Adviser.new
  end

  def create
    @adviser = create_or_update_adviser
    redirect_to advisers_path
  end

  def show
    @adviser = Adviser.find(params[:id])
  end

  def edit
    @adviser = Adviser.find(params[:id])
  end

  def update
    @adviser = create_or_update_adviser
    redirect_to @adviser
  end

  def destroy
    @adviser = Adviser.find(params[:id])
    @adviser.destroy
    redirect_to advisers_path
  end

  private
  def create_or_update_adviser
    uid = NUS_OPEN_ID_PREFIX + params[:nus_id]
    provider = NUS_OPEN_ID_PROVIDER
    email = params[:user_email]
    user_name = params[:user_name]
    user = User.create_or_update_by_provider_and_uid(uid: uid,
                                                     provider: provider,
                                                     email: email,
                                                     user_name: user_name)
    adviser = Adviser.create_or_update_adviser_by_user_id(user_id: user.id)
    return adviser
  end
end
