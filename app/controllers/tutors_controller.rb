# Tutors
class TutorsController < RolesController
  def role_cls
    Tutor
  end

  def role_params
    params.require(:tutor).permit(:user_id, :cohort)
  end

  def path_for_index(ps = {})
    tutors_path(ps)
  end

  def path_for_new(ps = {})
    new_tutor_path(ps)
  end

  def path_for_show(role_id)
    tutor_path(role_id)
  end
end
