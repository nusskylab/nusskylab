class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.references :team, index: true
      t.references :evaluating, index: true

      t.timestamps null: false
    end
    add_foreign_key :feedbacks, :teams
    add_foreign_key :feedbacks, :evaluatings
  end
end
