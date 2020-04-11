class AddIsPublicToQuestions < ActiveRecord::Migration
  def up
    add_column :questions, :is_public, :boolean, default: true
  end

  def down
    remove_column :questions, :is_public, :boolean, default: true
  end
end
