class AddDetailsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :team_name, :string
    add_column :teams, :project_title, :string
  end
end
