class Milestone < ActiveRecord::Base
  validates :name, presence: true,
            uniqueness: {message: 'Milestone name should be unique'}
  validates :deadline, presence: true
end
