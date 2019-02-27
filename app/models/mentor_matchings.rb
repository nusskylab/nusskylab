# MentorMatchings: mentor modeling
class MentorMatchings < ActiveRecord::Base
  validates :team_id, presence: true
  validates :mentor_id, presence: true
  validates :choice_ranking, presence: true
  validates :evaluator_id, presence: true, uniqueness: {
    scope: :evaluated_id, message: 'evaluating relationship should be unique'
  }

  belongs_to :team_id, foreign_key: :team_id, class_name: Team
  belongs_to :mentor_id, foreign_key: :mentor_id, class_name: Mentor