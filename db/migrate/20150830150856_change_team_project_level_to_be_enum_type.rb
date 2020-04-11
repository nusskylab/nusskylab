class ChangeTeamProjectLevelToBeEnumType < ActiveRecord::Migration
  def change
    rename_column :teams, :project_level, :project_level_str
    add_column :teams, :project_level, :integer, default: 0
    Team.where(project_level_str: 'Vostok').update_all(project_level: 0)
    Team.where(project_level_str: 'Gemini').update_all(project_level: 1)
    Team.where(project_level_str: 'Apollo 11').update_all(project_level: 2)
    Team.where(project_level_str: 'Artemis').update_all(project_level: 3)
    remove_column :teams, :project_level_str
  end
end
