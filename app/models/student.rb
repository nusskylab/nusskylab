class Student < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: {message: 'can have only one student role'}

  belongs_to :user
  belongs_to :team

  def self.student?(user_id)
    Student.find_by(user_id: user_id)
  end

  def get_teammates
    if self.team_id.nil?
      return []
    end
    teammates = []
    self.team.students.each do |student|
      if student.id != self.id
        teammates.push(student)
      end
    end
    teammates
  end
end
