class Adviser < ActiveRecord::Base
  validates :user_id, presence: true

  belongs_to :user
  has_many :teams

  def self.adviser?(user_id)
    Adviser.find_by(user_id: user_id)
  end
end
