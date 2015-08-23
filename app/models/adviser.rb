class Adviser < ActiveRecord::Base
  validates :user_id, presence: true,
            uniqueness: {message: 'can only have one adviser role'}

  belongs_to :user
  has_many :teams

  def self.adviser?(user_id)
    Adviser.find_by(user_id: user_id)
  end

  def get_advisee_users
    advisee_users = []
    self.teams.each do |team|
      advisee_users.concat(team.get_team_members)
    end
    return advisee_users
  end
end
