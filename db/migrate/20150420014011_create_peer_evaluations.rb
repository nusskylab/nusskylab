class CreatePeerEvaluations < ActiveRecord::Migration
  def change
    create_table :peer_evaluations do |t|
      t.text :public_content
      t.text :private_content
      t.date :submitted_date
      t.boolean :published
      t.references :team, index: true, null: false
      t.references :submission, index: true, null: false
    end
    add_foreign_key :peer_evaluations, :teams
    add_foreign_key :peer_evaluations, :submissions
  end
end
