class UsersController < ApplicationController
  def index
    not authenticate_user(true, true) and return
    @users = User.order(:user_name).all
  end

  def new
    not authenticate_user(true, true) and return
    @user = User.new
  end

  def create
    not authenticate_user(true, true) and return
    @user = User.new(get_user_params)
    if @user.save
      redirect_to users_path, flash: {success: t('.success_message')}
    else
      redirect_to new_user_path, flash: {danger: t('.failure_message',
                                                   error_message: @user.errors.full_messages.join(', '))}
    end
  end

  def show
    @user = User.find(params[:id])
    not authenticate_user(true, false, [@user]) and return
    render
  end

  def preview_as
    not authenticate_user(true, true) and return
    user = User.find(params[:id])
    sign_out(current_user)
    sign_in(user)
    redirect_to user_path(user.id)
  end

  def edit
    @user = User.find(params[:id])
    not authenticate_user(true, false, [@user]) and return
    render
  end

  def update
    @user = User.find(params[:id])
    not authenticate_user(true, false, [@user]) and return
    if @user and @user.update(get_user_params)
      redirect_to @user, flash: {success: t('.success_message')}
    else
      redirect_to @user, flash: {danger: t('.failure_message',
                                           error_message: @user.errors.full_messages.join(', '))}
    end
  end

  def destroy
    not authenticate_user(true, true) and return
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to users_path, flash: {success: t('.success_message')}
    else
      redirect_to users_path, flash: {danger: t('.failure_message')}
    end
  end

  private
  def get_user_params
    user_param = params.require(:user).permit(:user_name, :email, :uid, :provider)
    generated_password = Devise.friendly_token.first(8)
    user_param[:password] = generated_password
    user_param[:provider] = User.get_provider_from_raw(user_param[:provider])
    user_param
  end
end
