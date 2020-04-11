class AddTargetTeamIdAdviserIdAndTargetTypeToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :target_team_id, :integer, index: true
    add_foreign_key :feedbacks, :teams, column: :target_team_id
    add_reference :feedbacks, :adviser, index: true
    add_foreign_key :feedbacks, :advisers
    add_column :feedbacks, :target_type, :integer
  end
end
