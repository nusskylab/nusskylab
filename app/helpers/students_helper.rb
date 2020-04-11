module StudentsHelper
  def can_current_user_create_new_student
    current_user_admin?
  end

  def get_student_team_name(student)
    student.team ? student.team.team_name : 'Nil'
  end

  def get_student_team_project_level(student)
    student.team ? student.team.get_project_level : 'Nil'
  end

  def get_student_team_adviser_name(student)
    (student.team && student.team.adviser) ? student.team.adviser.user.user_name : 'Nil'
  end

  def get_student_team_dropped_status(student)
    student.team ? student.team.has_dropped : 'Nil'
  end
end
