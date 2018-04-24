class AddVideoLinkToTeams < ActiveRecord::Migration
    def change
      add_column :teams, :video_link, :string
    end
end