class AddHasDroppedToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :has_dropped, :boolean, default: false
  end
end
