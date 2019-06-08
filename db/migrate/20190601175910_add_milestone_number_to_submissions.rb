class AddMilestoneNumberToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :milestone_number, :integer, null:false, default:0
  end
end