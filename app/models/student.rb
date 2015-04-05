class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  def self.create_or_silent_failure(student_hash)
    where(user_id: student_hash[:user_id]).first_or_create do |student|
      student.user_id = student_hash[:user_id]
      student.team_id = student_hash[:team_id]
    end
  end
end
