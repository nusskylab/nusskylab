# Adviser: model of adviser role
class Adviser < ActiveRecord::Base
  include ModelHelper
  validates :user_id, presence: true, uniqueness: {
    scope: :cohort,
    message: 'can only have one adviser role for each cohort'
  }
  before_validation :fill_current_cohort

  belongs_to :user
  has_many :teams
  has_many :feedbacks

  def self.adviser?(user_id, extra = nil)
    if extra
      extra[:user_id] = user_id
      Adviser.find_by(extra)
    else
      Adviser.find_by(user_id: user_id)
    end
  end

  def self.to_csv(**options)
    require 'csv'
    if options[:cohort].nil?
      exported_advisers = all
    else
      exported_advisers = where(cohort: options[:cohort])
      options.delete(:cohort)
    end
    CSV.generate(options) do |csv|
      csv << ['Adviser UserID', 'Adviser Name', 'Adviser Email',
              'Avg feedback rating']
      exported_advisers.each do |adviser|
        csv << [adviser.user.id, adviser.user.user_name, adviser.user.email,
                adviser.feedback_average_rating]
      end
    end
  end

  def advisee_users
    advisee_users = []
    teams.each do |team|
      advisee_users.concat(team.get_team_members)
    end
    advisee_users
  end

  def advised_teams_evaluatings
    evaluatings = Evaluating.all
    adviser_evaluatings = []
    evaluatings.each do |evaluating|
      if evaluating.evaluated.adviser_id == id &&
         evaluating.evaluator.adviser_id == id
        adviser_evaluatings.append(evaluating)
      end
    end
    adviser_evaluatings
  end

  def feedback_average_rating
    ratings = []
    feedbacks.each do |feedback|
      ratings.append(feedback.get_response_for_question(1).to_i)
    end
    get_average_of_ratings(ratings)
  end

  def get_average_of_ratings(ratings)
    sum = ratings.reduce(:+)
    sum.to_f / ratings.length if ratings.length > 0
  end
end
