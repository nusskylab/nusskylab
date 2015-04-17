class Milestone < ActiveRecord::Base
  validates :name, presence: true,
            format: {with: /\A[_A-Za-z0-9 ]{5,}\z/,
                     message: 'At least 5 letters, numbers using spaces or underscores as deliminators'}
  validates :deadline, presence: true

  def self.create_or_update_by_name(milestone_hash)
    milestone = Milestone.find_by(name: milestone_hash[:name]) || Milestone.new
    milestone_hash.each_pair { |key, value| milestone[key] = value }
    milestone.save
    return milestone
  end
end
