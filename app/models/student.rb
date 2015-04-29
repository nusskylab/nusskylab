class Student < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: {message: 'can have only one student role'}

  belongs_to :user
  belongs_to :team

  def self.student?(user_id)
    Student.find_by(user_id: user_id)
  end
end
