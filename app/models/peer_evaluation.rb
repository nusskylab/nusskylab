# PeerEvaluation: peer_evaluation modeling
class PeerEvaluation < ActiveRecord::Base
  validates :submission_id, presence: true
  validates :submission_id, uniqueness: {
    scope: :team_id,
    message: 'A team can only evaluate a submission once'
  }, if: :evaluated_by_team
  validates :submission_id, uniqueness: {
    scope: :adviser_id,
    message: 'An adviser can only evaluate a submission once'
  }, if: :evaluated_by_adviser

  validate :check_evaluation_owner_presence

  belongs_to :team
  belongs_to :adviser
  belongs_to :submission

  def survey_template
    SurveyTemplate.find_by(milestone_id: submission.milestone_id,
                           survey_type: 1)
  end

  def get_response_for_question(question_id)
    response_content[question_id.to_s] unless response_content.blank?
  end

  def evaluated_by_team
    !team_id.blank?
  end

  def evaluated_by_adviser
    !adviser_id.blank?
  end

  def submitted_late?
    deadline = submission.milestone.peer_evaluation_deadline
    updated_at > deadline
  end

  # TODO: remove this matter later as it will be coupled with
  #   evaluating relation only
  def check_evaluation_owner_presence
    if adviser_id.blank? && team_id.blank?
      errors.add(:adviser_id,
                 'cannot be blank if evaluation is not owned by a team')
      errors.add(:team_id,
                 'cannot be blank if evaluation is not owned by an adviser')
    end
  end
end
