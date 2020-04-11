class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :admins, :users
  end
end
