module UsersHelper
  def user_admin?
    Admin.admin?(@user.id) if @user
  end

  def user_adviser?
    Adviser.adviser?(@user.id) if @user
  end

  def user_mentor?
    Mentor.mentor?(@user.id) if @user
  end

  def user_student?
    return unless @user
    stu = Student.student?(@user.id)
    stu if stu && !stu.is_pending
  end

  def user_pending_student?
    return unless @user
    stu = Student.student?(@user.id)
    stu if stu && stu.is_pending
  end
end
