class AdminLink < ActiveRecord::Base
    include ModelHelper
    self.primary_key = "id"
    validates :name, presence: true
    validates :url, presence: true
  end
  