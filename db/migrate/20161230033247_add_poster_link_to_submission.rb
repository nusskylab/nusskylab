class AddPosterLinkToSubmission < ActiveRecord::Migration
  def change
  	add_column :submissions, :poster_link, :string
  end
end
