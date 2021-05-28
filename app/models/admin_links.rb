class AdminLinks < ActiveRecord::Base
    include ModelHelper
    self.primary_key = "id"
    validates :name, presence: true
    validates :link, presence: true
  end
  