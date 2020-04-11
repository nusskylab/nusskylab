class ChangeCreatedAtAndSubmittedAtForPeerEvaluation < ActiveRecord::Migration
  def change
    change_column :peer_evaluations, :created_at, :datetime, null: false, default: Time.now
    change_column :peer_evaluations, :updated_at, :datetime, null: false, default: Time.now
  end
end
