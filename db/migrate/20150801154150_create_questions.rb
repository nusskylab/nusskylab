class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.references :feedback, index: true
      t.references :peer_evaluation, index: true

      t.timestamps null: false
    end
    add_foreign_key :questions, :feedbacks
    add_foreign_key :questions, :peer_evaluations
  end
end
