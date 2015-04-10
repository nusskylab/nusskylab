class Adviser < ActiveRecord::Base
  belongs_to :user
  has_many :teams

  def self.is_an_adviser(user_id)
    Adviser.find_by(user_id: user_id)
  end
end
