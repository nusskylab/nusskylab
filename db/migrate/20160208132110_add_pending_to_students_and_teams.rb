class AddPendingToStudentsAndTeams < ActiveRecord::Migration
  def up
    add_column :students, :is_pending, :boolean, default: true
    add_column :teams, :is_pending, :boolean, default: true
  end

  def down
    remove_column :students, :is_pending, :boolean, default: true
    remove_column :teams, :is_pending, :boolean, default: true
  end
end
