class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, null: false, default: 'NUS'
    add_column :users, :uid, :string, null: false
    add_column :users, :user_name, :string, null: false
  end
end
