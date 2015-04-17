class Submission < ActiveRecord::Base
  validates :milestone_id, presence: true
  validates :team_id, presence: true,
            uniqueness: {scope: :milestone_id,
                         message: 'A team can only submit one copy to every milestone'}

  belongs_to :milestone
  belongs_to :team

  validates :milestone_id, :team_id, :project_log, :read_me, :video_link, :presence => true

  def self.create_or_update_by_team_id_and_milestone_id(submission_hash)
    submission = Submission.find_by(team_id: submission_hash[:team_id],
                                    milestone_id: submission_hash[:milestone_id]) || Submission.new
    submission_hash.each_pair do |key, value|
      if submission.has_attribute?(key) and (not value.blank?)
        submission[key] = value
      end
    end
    submission.save
    return submission
  end
end
