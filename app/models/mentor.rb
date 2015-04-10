class Mentor < ActiveRecord::Base
  belongs_to :user
  has_many :teams

  def self.is_a_mentor(user_id)
    Mentor.find_by(user_id: user_id)
  end
end
