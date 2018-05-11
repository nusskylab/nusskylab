class AddSlideLinkToTeams < ActiveRecord::Migration
    def change
      add_column :teams, :slide_link, :string
    end
end