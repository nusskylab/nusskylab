class Adviser < ActiveRecord::Base
  validates :user_id, presence: true

  belongs_to :user
  has_many :teams

  def self.adviser?(user_id)
    Adviser.find_by(user_id: user_id)
  end

  def self.create_or_update_by_user_id(adviser_hash)
    adviser = Adviser.find_by(user_id: adviser_hash[:user_id]) || Adviser.new
    adviser_hash.each_pair do |key, value|
      if adviser.has_attribute?(key) and (not value.blank?)
        adviser[key] = value
      end
    end
    adviser.save
    return adviser
  end
end
