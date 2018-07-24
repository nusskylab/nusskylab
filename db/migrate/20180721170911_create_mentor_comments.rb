class CreateMentorComments < ActiveRecord::Migration
  def change
    create_table :mentor_comments do |t|
      t.references :mentor, index: true
      t.references :survey_template, index: true
      t.json :response_content
      t.integer :target_team_id, index: true
      t.timestamps null: false
    end
    add_foreign_key :mentor_comments, :mentors
    add_foreign_key :mentor_comments, :survey_templates
    add_foreign_key :mentor_comments, :teams, column: :target_team_id
  end
end
