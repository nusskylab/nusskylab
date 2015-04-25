class Evaluating < ActiveRecord::Base

  belongs_to :evaluator, foreign_key: :evaluator_id, class_name: Team
  belongs_to :evaluated, foreign_key: :evaluated_id, class_name: Team
end
