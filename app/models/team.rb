class Team < ActiveRecord::Base
  has_many :students
  belongs_to :adviser
  belongs_to :mentor

  def self.create_or_silent_failure(team_hash)
    where(team_name: team_hash[:team_name], project_title: team_hash[:project_title]).first_or_create do |team|
      team.team_name = team_hash[:team_name]
      team.project_title = team_hash[:project_title]
    end
  end
end
