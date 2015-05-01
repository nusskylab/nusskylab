class Adviser < ActiveRecord::Base
  validates :user_id, presence: true,
            uniqueness: {message: 'can only have one adviser role'}

  belongs_to :user
  has_many :teams

  def self.adviser?(user_id)
    Adviser.find_by(user_id: user_id)
  end
end
