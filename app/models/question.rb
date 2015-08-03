class Question < ActiveRecord::Base
  belongs_to :feedback
  belongs_to :peer_evaluation
end
