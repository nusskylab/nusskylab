class CreateSurveyTemplatesForPeerEvaluations < ActiveRecord::Migration
  def up
    survey_template1 = SurveyTemplate.new(
      instruction: 'Answer all questions below as evaluation for peer team',
      survey_type: 1,
      deadline: DateTime.new(2015, 6, 27, 24, 0, 0, '+8'),
      milestone_id: 1
    )
    survey_template1.save
    survey_template2 = SurveyTemplate.new(
      instruction: 'Answer all questions below as evaluation for peer team',
      survey_type: 1,
      deadline: DateTime.new(2015, 7, 14, 24, 0, 0, '+8'),
      milestone_id: 2
    )
    survey_template2.save
    survey_template3 = SurveyTemplate.new(
      instruction: 'Answer all questions below as evaluation for peer team',
      survey_type: 1,
      deadline: DateTime.new(2015, 8, 10, 24, 0, 0, '+8'),
      milestone_id: 3
    )
    survey_template3.save
  end

  def down
    survey_template = SurveyTemplate.find_by(milestone_id: 1, survey_type: 1)
    survey_template.destroy
    survey_template = SurveyTemplate.find_by(milestone_id: 2, survey_type: 1)
    survey_template.destroy
    survey_template = SurveyTemplate.find_by(milestone_id: 3, survey_type: 1)
    survey_template.destroy
  end
end
