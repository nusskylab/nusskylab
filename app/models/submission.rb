class Submission < ActiveRecord::Base
  belongs_to :milestone
  belongs_to :team

  validates :milestone_id, :team_id, :content, :presence => true

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
