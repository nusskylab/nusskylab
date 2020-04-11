class PublicProjectVideoChoose < ActiveRecord::Migration
  def change
  	add_column :submissions, :show_public, :boolean, default: true
  end
end
