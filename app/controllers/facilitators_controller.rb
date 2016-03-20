# Facilitators
class FacilitatorsController < RolesController
  def role_cls
    Facilitator
  end

  def role_params
    params.require(:facilitator).permit(:user_id, :cohort)
  end

  def path_for_index
    facilitators_path
  end

  def path_for_new
    new_facilitator_path
  end

  def path_for_edit(role_id)
    edit_facilitator_path(role_id)
  end

  def path_for_show(role_id)
    facilitator_path(role_id)
  end
end
