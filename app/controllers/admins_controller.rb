# AdminsController: manage actions related to Admin model/role.
#   index:   list all admins
#   new:     view to create a new admin for non-admin user
#   create:  create a new admin for non-admin user
#   show:    view and homepage for and admin
#   destroy: delete an admin
class AdminsController < ApplicationController
  def index
    !check_access(true, true) && return
    @page_title = t('.page_title')
    @admins = Admin.all
  end

  def new
    !check_access(true, true) && return
    @page_title = t('.page_title')
    @admin = Admin.new
    render locals: {
      users: User.all
    }
  end

  def create
    !check_access(true, true) && return
    user = User.find(params[:admin][:user_id])
    @admin = Admin.new(user_id: user.id)
    is_saved = @admin.save
    error_messages = @admin.errors.full_messages.join(' ')
    redirect_after_create_action(is_saved,
                                 user.user_name,
                                 error_messages) && return
  end

  def show
    !check_access(true, true) && return
    @admin = Admin.find(params[:id])
    @page_title = t('.page_title', user_name: @admin.user.user_name)
  end

  def destroy
    !check_access(true, true) && return
    @admin = Admin.find(params[:id])
    is_error = check_for_delete_self
    error_messages = @admin.errors.full_messages.join(' ')
    redirect_after_destroy_action(is_error, error_messages)
  end

  private

  def redirect_after_create_action(is_saved, user_name, error_messages)
    if is_saved
      redirect_to admins_path, flash: {
        success: t('.success_message', user_name: user_name)
      }
    else
      redirect_to new_admin_path, flash: {
        danger: t('.failure_message', error_messages: error_messages)
      }
    end
  end

  def check_for_delete_self
    is_error = (@admin.user_id == current_user.id)
    @admin.errors.add(:user_id, t('.cannot_delete_self_error')) if is_error
    is_error
  end

  def redirect_after_destroy_action(is_error, error_messages)
    if @admin.destroy && (!is_error)
      redirect_to admins_path, flash: {
        success: t('.success_message', user_name: @admin.user.user_name)
      }
    else
      redirect_to admins_path, flash: {
        danger: t('.failure_message', error_messages: error_messages)
      }
    end
  end
end
