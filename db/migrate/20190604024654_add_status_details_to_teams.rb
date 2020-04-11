class AddStatusDetailsToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :status, :integer, default: 0
    add_column :teams, :comment, :text
  end
end
