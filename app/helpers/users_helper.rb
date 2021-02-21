# Helper for users' views
module UsersHelper
  def user_admin?(cohort = nil)
    cohort ||= current_cohort
    Admin.admin?(@user.id, cohort: cohort) if @user
  end

  def user_adviser?(cohort = nil)
    cohort ||= current_cohort
    Adviser.adviser?(@user.id, cohort: cohort) if @user
  end

  def user_mentor?(cohort = nil)
    cohort ||= current_cohort
    Mentor.mentor?(@user.id, cohort: cohort) if @user
  end

  def user_student?(cohort = nil)
    cohort ||= current_cohort
    return unless @user
    stu = Student.student?(@user.id, cohort: cohort)
    stu if stu && !stu.application_status
  end

  def user_pending_student?(cohort = nil)
    cohort ||= current_cohort
    return unless @user
    stu = Student.student?(@user.id, cohort: cohort)
    stu if stu && stu.application_status
  end

  def current_cohort
    Time.now.year
  end
end
