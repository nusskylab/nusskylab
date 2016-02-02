class AdjustTagsForLabelAndIndex < ActiveRecord::Migration
  def up
    add_column :hash_tags, :label, :string, default: 'default'
    add_index :hash_tags, :content
    add_index :hash_tags, :label
  end

  def down
    remove_index :hash_tags, :content
    remove_index :hash_tags, :label
    remove_column :hash_tags, :label, :string, default: 'default'
  end
end
