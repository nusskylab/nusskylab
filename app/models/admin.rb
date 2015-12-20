# Admin: admin modeling
class Admin < ActiveRecord::Base
  validates :user_id, presence: true, uniqueness: {
    message: 'can only have one admin role'
  }

  belongs_to :user

  def self.admin?(user_id)
    Admin.find_by(user_id: user_id)
  end
end
