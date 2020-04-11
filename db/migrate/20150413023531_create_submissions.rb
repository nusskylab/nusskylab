class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.text :content
      t.references :milestone, index: true, null: false
      t.references :team, index: true, null: false
      t.boolean :published, default: false

      t.timestamps null: false
    end
    add_foreign_key :submissions, :milestones
    add_foreign_key :submissions, :teams
  end
end
