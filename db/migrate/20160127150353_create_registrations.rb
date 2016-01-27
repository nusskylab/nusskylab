class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.json :response_content
      t.references :user, index: true, foreign_key: true
      t.references :survey_template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
