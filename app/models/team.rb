class Team < ActiveRecord::Base
  validates :team_name, presence: true,
            uniqueness: {message: 'Team name should be unique'}
  validates :project_level, presence: true

  before_save :clean_project_level

  has_many :students
  belongs_to :adviser
  belongs_to :mentor
  has_many :submissions
  has_many :peer_evaluations
  has_many :evaluateds, class_name: :Evaluating, foreign_key: :evaluator_id
  has_many :evaluators, class_name: :Evaluating, foreign_key: :evaluated_id

  def clean_project_level
    case self.project_level
      when 'Vostok'
        self.project_level = 'Vostok'
      when 'Gemini'
        self.project_level = 'Gemini'
      when 'Apollo 11'
        self.project_level = 'Apollo 11'
      else
        self.project_level = 'Vostok'
    end
  end
end
