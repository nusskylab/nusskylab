class Adviser < ActiveRecord::Base
  validates :user_id, presence: true,
            uniqueness: {message: 'can only have one adviser role'}

  belongs_to :user
  has_many :teams
  has_many :feedbacks

  def self.adviser?(user_id)
    Adviser.find_by(user_id: user_id)
  end

  def self.to_csv(**options)
    require 'csv'
    CSV.generate(options) do |csv|
      csv << ['Adviser UserID', 'Adviser Name', 'Adviser Email', 'Avg feedback rating']
      self.all.each do |adviser|
        csv << [adviser.user.id, adviser.user.user_name, adviser.user.email,
                adviser.get_feedback_average_rating]
      end
    end
  end

  def get_advisee_users
    advisee_users = []
    self.teams.each do |team|
      advisee_users.concat(team.get_team_members)
    end
    advisee_users
  end

  def get_advised_teams_evaluatings
    evaluatings = Evaluating.all
    adviser_evaluatings = []
    evaluatings.each do |evaluating|
      if evaluating.evaluated.adviser_id == self.id and evaluating.evaluator.adviser_id == self.id
        adviser_evaluatings.append(evaluating)
      end
    end
    adviser_evaluatings
  end

  # Get the average rating of feedback received by adviser
  #   Will be changed along with feedback change later
  def get_feedback_average_rating
    recv_feedbacks = self.feedbacks
    ratings = []
    recv_feedbacks.each do |feedback|
      response = feedback.get_response_for_question(1).nil? ? 0 : feedback.get_response_for_question(1).to_i
      ratings.append(response)
    end
    get_average_of_ratings(ratings)
  end

  def get_average_of_ratings(ratings)
    sum = 0; acc = 0;
    ratings.each do |num|
      sum = sum + num; acc = acc + 1
    end
    if acc > 0
      sum.to_f / acc
    else
      nil
    end
  end
end
