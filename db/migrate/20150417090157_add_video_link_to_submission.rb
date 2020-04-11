class AddVideoLinkToSubmission < ActiveRecord::Migration
  def change
    add_column :submissions, :video_link, :string
    add_column :submissions, :read_me, :text
    add_column :submissions, :project_log, :text
  end
end
