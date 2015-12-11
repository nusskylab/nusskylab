# Milestone: milestone modeling
class Milestone < ActiveRecord::Base
  validates :name, presence: true, uniqueness: {
    message: 'should be unique'
  }
  validates :submission_deadline, presence: true
  validates :peer_evaluation_deadline, presence: true

  def get_prev_milestone
    milestones = Milestone.order(:created_at).all
    milestone_idx = milestones.index { |itm| itm.id == id }
    milestones[milestone_idx - 1] unless milestone_idx.to_i <= 0
  end

  # A temporary solution for getting average rating question id
  #   for peer evaluations
  def get_overall_rating_question_id
    case name
    when 'Milestone 1'
      return 'q[5][1]'
    when 'Milestone 2'
      return 'q[6][1]'
    when 'Milestone 3'
      return 'q[6][1]'
    else
      return 'NON_EXISTENT'
    end
  end
end
