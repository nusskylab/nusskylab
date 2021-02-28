class ApplicationDeadlines < ActiveRecord::Base
    include ModelHelper
    self.primary_key = "id"
    validates :name, presence: true
    validates :submission_deadline, presence: true
    # before_validation :fill_current_cohort #to-do
  end
  