# Evaluating: evaluating relationship modeling
# to-do: foreign key
class ApplicantEvaluatings < ActiveRecord::Base
  validates :evaluator_students, presence: true, uniqueness: {
    scope: :evaluator_students, message: 'evaluating relationship should be unique'
  }
  validates :evaluatee_ids, presence: true
end
