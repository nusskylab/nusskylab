class ChangePeerEvaluationTimestampDefault < ActiveRecord::Migration
  def change
    change_column_default :peer_evaluations, :created_at, nil
    change_column_default :peer_evaluations, :updated_at, nil
  end
end
