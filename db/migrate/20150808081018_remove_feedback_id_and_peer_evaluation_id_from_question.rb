class RemoveFeedbackIdAndPeerEvaluationIdFromQuestion < ActiveRecord::Migration
  def change
    remove_foreign_key :questions, :feedbacks
    remove_reference :questions, :feedback, index: true
    remove_foreign_key :questions, :peer_evaluations
    remove_reference :questions, :peer_evaluation, index: true
  end
end
