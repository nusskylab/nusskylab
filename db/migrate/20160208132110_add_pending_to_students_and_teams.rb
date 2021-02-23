class AddPendingToStudentsAndTeams < ActiveRecord::Migration
  def up
    add_column :students, :application_status, :string, default: 'a'
    add_column :teams, :application_status, :string, default: 'a'
  end

  def down
    remove_column :students, :application_status, :string, default: 'a'
    remove_column :teams, :application_status, :string, default: 'a'
  end
end
