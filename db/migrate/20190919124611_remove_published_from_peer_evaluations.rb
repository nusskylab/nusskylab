class RemovePublishedFromPeerEvaluations < ActiveRecord::Migration
  def change
    remove_column :peer_evaluations, :published, :boolean
  end
end
