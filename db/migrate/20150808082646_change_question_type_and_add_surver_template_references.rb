class ChangeQuestionTypeAndAddSurverTemplateReferences < ActiveRecord::Migration
  def up
    remove_column :questions, :type, :string
    add_column :questions, :question_type, :integer, default: 0
    add_reference :questions, :survey_template, null: false, index: true
    add_foreign_key :questions, :survey_templates
  end

  def down
    add_column :questions, :type, :string
    remove_column :questions, :question_type, :integer, default: 0
    remove_foreign_key :questions, :survey_templates
    remove_reference :questions, :survey_template, null: false, index: true
  end
end
