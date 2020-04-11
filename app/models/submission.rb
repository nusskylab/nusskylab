# Submission: submission modeling
class Submission < ActiveRecord::Base
  validates :milestone_id, presence: true
  validates :team_id, presence: true, uniqueness: {
    scope: :milestone_id,
    message: 'each team can only submit one copy to every milestone'
  }
  validates :project_log, :read_me, :video_link, :show_public, presence: true

  belongs_to :milestone
  belongs_to :team

  def submitted_late?
    updated_at > milestone.submission_deadline
  end

  def get_milestone_number
    if milestone_number == 0
      (milestone_id - 1) % 3 + 1
    else
      milestone_number
    end
  end
end
