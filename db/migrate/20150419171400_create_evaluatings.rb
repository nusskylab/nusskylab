class CreateEvaluatings < ActiveRecord::Migration
  def change
    create_table :evaluatings do |t|
      t.integer :evaluator_id, index: true, null: false
      t.integer :evaluated_id, index: true, null: false
    end
    add_foreign_key :evaluatings, :teams, column: :evaluator_id
    add_foreign_key :evaluatings, :teams, column: :evaluated_id
  end
end
