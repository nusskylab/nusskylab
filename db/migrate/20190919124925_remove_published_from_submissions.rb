class RemovePublishedFromSubmissions < ActiveRecord::Migration
  def change
    remove_column :submissions, :published, :boolean
  end
end
