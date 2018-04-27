class AddPosterAndVideoLinkToTeams < ActiveRecord::Migration
  def up
    add_column :teams, :poster_link, :string
    add_column :teams, :video_link, :string
  end
end
