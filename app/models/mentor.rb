class Mentor < ActiveRecord::Base
  validates :user_id, presence: true

  belongs_to :user
  has_many :teams

  def self.is_a_mentor(user_id)
    Mentor.find_by(user_id: user_id)
  end

  def self.create_or_update_by_user_id(mentor_hash)
    mentor = Mentor.find_by(user_id: mentor_hash[:user_id]) || Mentor.new
    mentor_hash.each_pair do |key, value|
      if mentor.has_attribute?(key) and (not value.blank?)
        mentor[key] = value
      end
    end
    mentor.save
    return mentor
  end
end
