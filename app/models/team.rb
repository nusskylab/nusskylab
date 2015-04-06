class Team < ActiveRecord::Base
  has_many :students
  belongs_to :adviser
  belongs_to :mentor

  def self.create_or_update_by_team_name(team_hash)
    team = Team.find_by(team_name: team_hash[:team_name]) || Team.new
    team_hash.each_pair { |key, value| team[key] = value }
    team.save
    return team
  end
end
