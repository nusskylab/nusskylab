class Student < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  def self.create_or_update_by_user_id(student_hash)
    student = Student.find_by(user_id: student_hash[:user_id]) || Student.new
    student_hash.each_pair { |key, value| student[key] = value }
    student.save
    return student
  end
end
