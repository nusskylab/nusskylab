class AddProjectLevelToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :project_level, :string
  end
end
