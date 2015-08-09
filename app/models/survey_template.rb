class SurveyTemplate < ActiveRecord::Base
  has_many :questions

  enum survey_type: [:survey_type_submission, :survey_type_peer_evaluation, :survey_type_feedback]
end
