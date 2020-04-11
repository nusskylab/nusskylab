class MoveRegistrationToCohortMilestone < ActiveRecord::Migration
  def up
    survey_template = SurveyTemplate.find_by(milestone_id: 1, survey_type: 3)
    return unless survey_template
    milestone = Milestone.new(name: 'Milestone 1', cohort: 2016)
    milestone.save
    survey_template.milestone_id = milestone.id
    survey_template.save
  end

  def down
    milestone = Milestone.find_by(name: 'Milestone 1', cohort: 2016)
    survey_template = SurveyTemplate.find_by(
      milestone_id: milestone.id, survey_type: 3)
    survey_template.milestone_id = 1
    survey_template.save
    milestone.destroy
  end
end
