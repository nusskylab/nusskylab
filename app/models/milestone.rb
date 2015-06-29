class Milestone < ActiveRecord::Base
  validates :name, presence: true,
            uniqueness: {message: 'Milestone name should be unique'}
  validates :submission_deadline, presence: true
  validates :peer_evaluation_deadline, presence: true

  def get_prev_milestone
    milestones = Milestone.order(:submission_deadline).all()
    milestone_idx = milestones.index { |itm| itm.id == self.id}
    if milestone_idx.nil? or milestone_idx <= 0
      return nil
    else
      return milestones[milestone_idx - 1]
    end
  end
end
