class ChangeUserProviderToBeEnum < ActiveRecord::Migration
  def change
    rename_column :users, :provider, :provider_str
    add_column :users, :provider, :integer, default: 0
    execute <<-SQL
      update users set provider = 1
    SQL
    remove_column :users, :provider_str
  end
end
