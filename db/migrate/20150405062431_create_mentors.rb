class CreateMentors < ActiveRecord::Migration
  def change
    create_table :mentors do |t|
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :mentors, :users
  end
end
