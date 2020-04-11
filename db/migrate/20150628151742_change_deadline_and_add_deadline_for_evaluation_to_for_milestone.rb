class ChangeDeadlineAndAddDeadlineForEvaluationToForMilestone < ActiveRecord::Migration
  def change
    change_column :milestones, :deadline, :datetime, null: false, default: Time.now
    rename_column :milestones, :deadline, :submission_deadline
    add_column :milestones, :peer_evaluation_deadline, :datetime, null: false, default: Time.now
  end
end
