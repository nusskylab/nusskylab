# SurveyTemplate: survey_template modeling
class SurveyTemplate < ActiveRecord::Base
  has_many :questions
  belongs_to :milestone
  validates :survey_type, uniqueness: {
    scope: :milestone_id,
    message: ': a milestone can have one of each type of survey_templates'
  }

  enum survey_type: [:survey_type_submission, :survey_type_peer_evaluation,
                     :survey_type_feedback, :survey_type_registration]
end
