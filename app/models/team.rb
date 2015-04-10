class Team < ActiveRecord::Base
  has_many :students
  belongs_to :adviser
  belongs_to :mentor

  def self.create_or_update_by_team_name(team_hash)
    team = Team.find_by(team_name: team_hash[:team_name]) || Team.new
    team_hash.each_pair do |key, value|
      if team.has_attribute?(key) and (not value.blank?)
        team[key] = value
      end
    end
    team.save
    return team
  end
end
