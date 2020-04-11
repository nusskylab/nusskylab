class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: ''
      t.string :provider,           null: false, default: 'NUS'
      t.string :uid,                null: false
      t.string :user_name,          null: false
      t.timestamps
    end
  end
end
