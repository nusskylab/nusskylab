class AddRegistrationSurveyTemplate < ActiveRecord::Migration
  def up
    survey_template = SurveyTemplate.new(
      instruction: 'Answer all questions below to complete registration',
      survey_type: 3,
      deadline: DateTime.new(2016, 5, 1, 24, 0, 0, '+8'),
      milestone_id: 1
    )
    survey_template.save if Milestone.find_by(id: 1)
  end

  def down
    survey_template = SurveyTemplate.find_by(milestone_id: 1, survey_type: 3)
    survey_template.questions.each(&:destroy) if survey_template
    survey_template.destroy if survey_template
  end
end
