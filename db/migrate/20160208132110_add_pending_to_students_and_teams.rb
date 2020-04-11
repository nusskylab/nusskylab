class AddPendingToStudentsAndTeams < ActiveRecord::Migration
  def up
    add_column :students, :is_pending, :boolean, default: false
    add_column :teams, :is_pending, :boolean, default: false
  end

  def down
    remove_column :students, :is_pending, :boolean, default: false
    remove_column :teams, :is_pending, :boolean, default: false
  end
end
