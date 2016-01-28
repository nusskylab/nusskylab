class ChangeUidInUsers < ActiveRecord::Migration
  def up
    change_column :users, :uid, :string, null: true
  end

  def down
    change_column :users, :uid, :string, null: false
  end
end
