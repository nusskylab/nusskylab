class Submission < ActiveRecord::Base
  validates :milestone_id, presence: true
  validates :team_id, presence: true,
            uniqueness: {scope: :milestone_id,
                         message: 'A team can only submit one copy to every milestone'}
  validates :project_log, :read_me, :video_link, presence: true

  belongs_to :milestone
  belongs_to :team
end
