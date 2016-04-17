# Facilitators
class FacilitatorsController < RolesController
  def role_cls
    Facilitator
  end

  def role_params
    params.require(:facilitator).permit(:user_id, :cohort)
  end

  def path_for_index(ps = {})
    facilitators_path(ps)
  end

  def path_for_new(ps = {})
    new_facilitator_path(ps)
  end

  def path_for_show(role_id)
    facilitator_path(role_id)
  end
end
