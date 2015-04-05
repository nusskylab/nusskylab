class Team < ActiveRecord::Base
  has_many :students
  belongs_to :adviser
  belongs_to :mentor
end
