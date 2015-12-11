# Mentor: mentor modeling
class Mentor < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: {
    message: 'can only have one mentor role'
  }

  belongs_to :user
  has_many :teams

  def self.mentor?(user_id)
    Mentor.find_by(user_id: user_id)
  end
end
