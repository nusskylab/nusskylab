# Mentor: mentor modeling
class Mentor < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: {
    scope: :cohort,
    message: 'can only have one mentor role for each cohort'
  }

  belongs_to :user
  has_many :teams

  def self.mentor?(user_id, extra = nil)
    if extra
      extra[:user_id] = user_id
      Mentor.find_by(extra)
    else
      Mentor.find_by(user_id: user_id)
    end
  end
end
