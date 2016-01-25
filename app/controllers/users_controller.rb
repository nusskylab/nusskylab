# UsersController: manage actions related to user
#   index:      list of users
#   new:        view to create a user
#   create:     create a user
#   preview_as: for admin to login as another user
#   edit:       view to update a user
#   update:     update a user
#   destroy:    delete a user
class UsersController < ApplicationController
  def index
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    @users = User.order(:user_name).all
  end

  def new
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    @user = User.new
  end

  def create
    !authenticate_user(true, true) && return
    @user = User.new(user_params(true))
    if @user.save
      redirect_to users_path, flash: {
        success: t('.success_message')
      }
    else
      redirect_to new_user_path, flash: {
        danger: t('.failure_message',
                  error_message: @user.errors.full_messages.join(', '))
      }
    end
  end

  def preview_as
    !authenticate_user(true, true) && return
    user = User.find(params[:id]) || (record_not_found && return)
    sign_out(current_user)
    sign_in(user)
    redirect_to user_path(user.id)
  end

  def register_as_student
    @user = User.find(params[:id])
  end

  def register
    @user = User.find(params[:id])
    redirect_to user_path(@user.id)
  end

  def show
    @user = User.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@user]) && return
    @page_title = t('.page_title', user_name: @user.user_name)
  end

  def edit
    @user = User.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@user]) && return
    @page_title = t('.page_title', user_name: @user.user_name)
  end

  def update
    @user = User.find(params[:id]) || (record_not_found && return)
    !authenticate_user(true, false, [@user]) && return
    user_ps = user_params
    user_ps.except!(:provider)
    if @user.update(user_ps)
      redirect_to @user, flash: {
        success: t('.success_message')
      }
    else
      redirect_to @user, flash: {
        danger: t('.failure_message',
                  error_message: @user.errors.full_messages.join(', '))
      }
    end
  end

  def destroy
    !authenticate_user(true, true) && return
    @user = User.find(params[:id])
    if @user.destroy
      redirect_to users_path, flash: {
        success: t('.success_message')
      }
    else
      redirect_to users_path, flash: {
        danger: t('.failure_message',
                  error_message: @user.errors.full_messages.join(', '))
      }
    end
  end

  private

  def user_params(generate_pswd = false)
    user_ps = params.require(:user).permit(
      :user_name, :email, :uid, :provider, :github_link, :linkedin_link,
      :blog_link, :program_of_study, :self_introduction)
    user_ps[:password] = Devise.friendly_token.first(8) if generate_pswd
    user_ps[:provider] = user_ps[:provider].to_i
    user_ps[:program_of_study] = user_ps[:program_of_study].to_i
    user_ps
  end
end
