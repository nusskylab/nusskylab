class ChangeDatetimeForPeerEvaluation < ActiveRecord::Migration
  def change
    rename_column :peer_evaluations, :submitted_date, :created_at
    add_column :peer_evaluations, :updated_at, :datetime
    execute <<-SQL
      update peer_evaluations set updated_at = created_at
    SQL
  end
end
