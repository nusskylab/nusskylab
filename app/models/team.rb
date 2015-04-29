class Team < ActiveRecord::Base
  validates :team_name, presence: true
  validates :project_level, presence: true

  has_many :students
  belongs_to :adviser
  belongs_to :mentor
  has_many :submissions
  has_many :peer_evaluations
  has_many :evaluateds, class_name: :Evaluating, foreign_key: :evaluator_id
  has_many :evaluators, class_name: :Evaluating, foreign_key: :evaluated_id
end
