class RemoveEvaluatingFromFeedback < ActiveRecord::Migration
  def change
    remove_foreign_key :feedbacks, :evaluatings
    remove_reference :feedbacks, :evaluating, index: true
  end
end
