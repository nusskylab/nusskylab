module StudentsHelper
  def can_current_user_create_new_student
    is_current_user_admin?
  end
end
