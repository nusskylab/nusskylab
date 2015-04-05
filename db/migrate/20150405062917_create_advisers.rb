class CreateAdvisers < ActiveRecord::Migration
  def change
    create_table :advisers do |t|
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :advisers, :users
  end
end
