class CreateSurveyTemplates < ActiveRecord::Migration
  def change
    create_table :survey_templates do |t|
      t.text :instruction
      t.datetime :deadline
      t.integer :survey_type, default: 0

      t.timestamps null: false
    end
  end
end
