# SurveyTemplate: survey_template modeling
class SurveyTemplate < ActiveRecord::Base
  has_many :questions
  belongs_to :milestone

  enum survey_type: [:survey_type_submission, :survey_type_peer_evaluation,
                     :survey_type_feedback]
end
