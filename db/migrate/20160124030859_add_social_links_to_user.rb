class AddSocialLinksToUser < ActiveRecord::Migration
  def up
    add_column :users, :github_link, :string, default: ''
    add_column :users, :linkedin_link, :string, default: ''
    add_column :users, :blog_link, :string, default: ''
  end

  def down
    remove_column :users, :github_link, :string
    remove_column :users, :linkedin_link, :string
    remove_column :users, :blog_link, :string
  end
end
