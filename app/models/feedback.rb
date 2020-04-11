# Feedback: feedback modeling
class Feedback < ActiveRecord::Base
  validates :team_id, presence: true
  validates :survey_template_id, presence: true
  validates :target_team_id, uniqueness: {
    scope: :team_id,
    message: ' cannot submit duplicated feedback'
  }, if: :target_type_team?
  validates :adviser_id, uniqueness: {
    scope: :team_id,
    message: ' cannot submit duplicated feedback'
  }, if: :target_type_adviser?

  belongs_to :team
  belongs_to :target_team, foreign_key: :target_team_id, class_name: Team
  belongs_to :adviser
  belongs_to :survey_template

  enum target_type: [:target_type_team, :target_type_adviser]

  def get_response_for_question(question_id)
    response_content[question_id.to_s] unless response_content.blank?
  end
end
