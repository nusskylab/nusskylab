class AddMilestoneIdToSurveyTemplate < ActiveRecord::Migration
  def change
    add_reference :survey_templates, :milestone, index: true
    add_foreign_key :survey_templates, :milestones
  end
end
