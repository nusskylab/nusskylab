class Team < ActiveRecord::Base
  validates :team_name, presence: true,
            uniqueness: {message: 'A team name should be unique'}
  validates :project_level, :project_title, presence: true

  has_many :students
  belongs_to :adviser
  belongs_to :mentor
  has_many :submissions
  has_many :peer_evaluations
  has_many :evaluateds, class_name: :Evaluating, foreign_key: :evaluator_id
  has_many :evaluators, class_name: :Evaluating, foreign_key: :evaluated_id

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
