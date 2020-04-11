class ChangeConstraintsForPeerEvaluation < ActiveRecord::Migration
  def change
    change_column :peer_evaluations, :team_id, :integer, null: true
    change_column :peer_evaluations, :submission_id, :integer, null: true
  end
end
