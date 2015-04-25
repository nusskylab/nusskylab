class PeerEvaluation < ActiveRecord::Base
  validates :team_id, :submission_id, presence: true

  belongs_to :team
  belongs_to :submission
end
