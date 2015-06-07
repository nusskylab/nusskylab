class PeerEvaluation < ActiveRecord::Base
  validates :submission_id, presence: true
  validates :submission_id,
            uniqueness: {
              scope: :team_id,
              message: 'A team can only evaluate a submission once'},
            :if => :evaluated_by_team
  validates :submission_id,
            uniqueness: {
              scope: :adviser_id,
              message: 'An adviser can only evaluate a submission once'},
            :if => :evaluated_by_adviser

  belongs_to :team
  belongs_to :adviser
  belongs_to :submission

  def evaluated_by_team
    not self.team_id.blank?
  end

  def evaluated_by_adviser
    not self.adviser_id.blank?
  end
end
