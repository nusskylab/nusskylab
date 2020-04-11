class RemoveContentFromSubmission < ActiveRecord::Migration
  def change
    remove_column :submissions, :content, :text
  end
end
