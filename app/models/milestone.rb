class Milestone < ActiveRecord::Base

  def self.create_or_update_by_name(milestone_hash)
    milestone = Milestone.find_by(name: milestone_hash[:name]) || Milestone.new
    milestone_hash.each_pair { |key, value| milestone[key] = value }
    milestone.save
    return milestone
  end
end
