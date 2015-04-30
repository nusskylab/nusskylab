class PeerEvaluation < ActiveRecord::Base
  validates :submission_id, presence: true

  before_save :init_date

  belongs_to :team
  belongs_to :adviser
  belongs_to :submission

  def init_date
    self.submitted_date = Date.today if new_record?
  end
end
