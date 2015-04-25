class Evaluating < ActiveRecord::Base
  validate :evaluated_id, :evaluator_id, presence: true

  belongs_to :evaluator, foreign_key: :evaluator_id, class_name: Team
  belongs_to :evaluated, foreign_key: :evaluated_id, class_name: Team
end
