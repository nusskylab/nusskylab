class ApplicationDeadline < ActiveRecord::Base
    include ModelHelper
    self.primary_key = "id"
    validates :name, presence: true
    validates :submission_deadline, presence: true
  end
  