class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.references :adviser, index: true
      t.references :mentor, index: true

      t.timestamps null: false
    end
    add_foreign_key :teams, :advisers
    add_foreign_key :teams, :mentors
  end
end
