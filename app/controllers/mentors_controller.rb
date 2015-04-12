class MentorsController < ApplicationController
  NUS_OPEN_ID_PREFIX = 'https://openid.nus.edu.sg/'
  NUS_OPEN_ID_PROVIDER = 'NUS'

  def index
    @mentors = Mentor.all
  end

  def new
    @mentor = Mentor.new
  end

  def create
    @mentor = create_or_update_mentor
    redirect_to mentors_path
  end

  def show
    @mentor = Mentor.find(params[:id])
  end

  def edit
    @mentor = Mentor.find(params[:id])
  end

  def update
    @mentor = create_or_update_mentor
    redirect_to @mentor
  end

  def destroy
    @mentor = Mentor.find(params[:id])
    @mentor.destroy
    redirect_to mentors_path
  end

  private
  def create_or_update_mentor
    uid = NUS_OPEN_ID_PREFIX + params[:nus_id]
    provider = NUS_OPEN_ID_PROVIDER
    email = params[:user_email]
    user_name = params[:user_name]
    user = User.create_or_update_by_provider_and_uid(uid: uid,
                                                     provider: provider,
                                                     email: email,
                                                     user_name: user_name)
    mentor = Mentor.create_or_update_by_user_id(user_id: user.id)
    return mentor
  end
end
