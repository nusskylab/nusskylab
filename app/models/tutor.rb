# Tutor role
class Tutor < ActiveRecord::Base
  include ModelHelper
  belongs_to :user
  before_validation :fill_current_cohort
  validates :user_id, presence: true, uniqueness: {
    scope: :cohort,
    message: 'can only have one tutor role for each cohort'
  }
end
