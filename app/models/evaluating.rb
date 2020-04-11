# Evaluating: evaluating relationship modeling
class Evaluating < ActiveRecord::Base
  validates :evaluated_id, presence: true
  validates :evaluator_id, presence: true, uniqueness: {
    scope: :evaluated_id, message: 'evaluating relationship should be unique'
  }

  belongs_to :evaluator, foreign_key: :evaluator_id, class_name: Team
  belongs_to :evaluated, foreign_key: :evaluated_id, class_name: Team
end
