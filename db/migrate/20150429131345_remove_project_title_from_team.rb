class RemoveProjectTitleFromTeam < ActiveRecord::Migration
  def change
    remove_column :teams, :project_title, :string
  end
end
