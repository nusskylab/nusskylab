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
    Student.student?(@user.id) if @user
  end
end
