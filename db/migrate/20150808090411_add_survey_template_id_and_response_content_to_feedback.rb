class AddSurveyTemplateIdAndResponseContentToFeedback < ActiveRecord::Migration
  def up
    add_reference :feedbacks, :survey_template, index: true
    add_foreign_key :feedbacks, :survey_templates
    add_column :feedbacks, :response_content, :json
  end

  def down
    remove_foreign_key :feedbacks, :survey_templates
    remove_reference :feedbacks, :survey_template, index: true
    remove_column :feedbacks, :response_content, :json
  end
end
