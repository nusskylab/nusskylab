class AdminsController < ApplicationController
  def index
    not check_access(true, true) and return
    @page_title = t('.page_title')
    @admins = Admin.all
  end

  def new
    not check_access(true, true) and return
    @page_title = t('.page_title')
    @admin = Admin.new
    render locals: {
             users: User.all
           }
  end

  def create
    not check_access(true, true) and return
    user = User.find(params[:admin][:user_id])
    @admin = Admin.new(user_id: user.id)
    if @admin.save
      redirect_to admins_path, flash: {success: t('.success_message', user_name: user.user_name)}
    else
      redirect_to new_admin_path, flash: {danger: t('.failure_message',
                                                     error_messages: @admin.errors.full_messages.join(' '))}
    end
  end

  def show
    not check_access(true, true) and return
    @admin = Admin.find(params[:id])
    @page_title = t('.page_title', user_name: @admin.user.user_name)
  end

  def destroy
    not check_access(true, true) and return
    @admin = Admin.find(params[:id])
    if @admin.user_id == current_user.id
      @admin.errors.add(:user_id, t('.cannot_delete_self_error'))
      is_error = true
    else
      is_error = false
    end
    if @admin.destroy and (not is_error)
      redirect_to admins_path, flash: {success: t('.success_message', user_name: @admin.user.user_name)}
    else
      redirect_to admins_path, flash: {danger: t('.failure_message',
                                                 error_messages: @admin.errors.full_messages.join(' '))}
    end
  end
end
