# AdminsController
class AdminsController < RolesController
  def role_cls
    Admin
  end

  def role_params
    params.require(:admin).permit(:user_id, :cohort)
  end

  def path_for_index(ps = {})
    admins_path(ps)
  end

  def path_for_new(ps = {})
    new_admin_path(ps)
  end

  def path_for_new_batch(ps ={})
    new_batch_admins_path(ps)
  end

  def path_for_show(role_id)
    admin_path(role_id)
  end

  def can_destroy_role?
    is_error = (@role.user_id == current_user.id)
    @role.errors.add(:user_id, t('.cannot_delete_self_error')) if is_error
    !is_error
  end

  def data_for_role_general_mailing
    {
      users: User.all
    }
  end

  def toggle_registration
    Config.toggle_registration()
    redirect_to admin_path(params[:id])
  end

  def toggle_project_level_swap
    Config.toggle_project_level_swap()
    redirect_to admin_path(params[:id])
  end
end
