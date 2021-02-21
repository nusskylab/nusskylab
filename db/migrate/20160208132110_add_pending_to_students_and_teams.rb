class AddPendingToStudentsAndTeams < ActiveRecord::Migration
  def up
    add_column :students, :application_status, :boolean, default: 1
    add_column :teams, :application_status, :boolean, default: 1
  end

  def down
    remove_column :students, :application_status, :boolean, default: 1
    remove_column :teams, :application_status, :boolean, default: 1
  end
end
