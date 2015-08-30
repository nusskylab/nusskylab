class Team < ActiveRecord::Base
  validates :team_name, presence: true,
            uniqueness: {message: ': Team name should be unique'}

  has_many :students
  belongs_to :adviser
  belongs_to :mentor
  has_many :submissions
  has_many :peer_evaluations
  has_many :feedbacks
  has_many :evaluateds, class_name: :Evaluating, foreign_key: :evaluator_id
  has_many :evaluators, class_name: :Evaluating, foreign_key: :evaluated_id

  VOSTOK_REGEX = /\A(?:v)|(?:vostok)\z/
  PROJECT_GEMINI_REGEX = /\A(?:project gemini)|(?:gemini)|(?:g)\z/
  APOLLO_11_REGEX = /\A(?:apollo 11)|(?:apollo)|(?:a)\z/
  enum project_level: [:vostok, :project_gemini, :apollo_11]

  def set_project_level(project_level)
    if project_level[VOSTOK_REGEX]
      self.project_level = Team.project_levels[:vostok]
    elsif project_level[PROJECT_GEMINI_REGEX]
      self.project_level = Team.project_levels[:project_gemini]
    elsif project_level[APOLLO_11_REGEX]
      self.project_level = Team.project_levels[:apollo_11]
    end
  end

  # Get a team's students, adviser, mentor as user and if include_* is true,
  #   team's evaluator and evaluated teams' members will be included
  def get_relevant_users(include_evaluator = false, include_evaluated = false)
    relevant_users = self.get_team_members
    if not self.adviser_id.blank?
      relevant_users.append(self.adviser.user)
    end
    if not self.mentor_id.blank?
      relevant_users.append(self.mentor.user)
    end
    if include_evaluator
      relevant_users.concat(self.get_evaluator_teams_members)
    end
    if include_evaluated
      relevant_users.concat(self.get_evaluated_teams_members)
    end
    return relevant_users
  end

  # Get team's own submissions as hash with milestone_id as key
  def get_own_submissions_as_hash
    submissions_hash = {}
    self.submissions.each do |submission|
      submissions_hash[submission.milestone_id] = submission
    end
    return submissions_hash
  end

  # Get team's evaluated teams' submissions as hash,
  #   first level of keys are milestone_id
  #   second level of keys are evaluating_id
  def get_evaluated_submissions_as_hash
    evaluated_submissions_hash = {}
    milestones = Milestone.all
    milestones.each do |milestone|
      evaluated_submissions_hash[milestone.id] = {}
      self.evaluateds.each do |evaluated|
        evaluated_submissions_hash[milestone.id][evaluated.id] = Submission.find_by(team_id: evaluated.evaluated_id,
                                                                                    milestone_id: milestone.id)
      end
    end
    return evaluated_submissions_hash
  end

  # Get own peer evaluations as hash with evaluated teams' submission ids as keys
  def get_own_peer_evaluations_for_evaluated_teams_as_hash
    own_peer_evaluations_hash = {}
    self.peer_evaluations.each do |peer_evaluation|
      own_peer_evaluations_hash[peer_evaluation.submission_id] = peer_evaluation
    end
    return own_peer_evaluations_hash
  end

  # Get peer evaluations for self as hash, first level of keys are milestone_ids
  #   second level of keys are evaluating_ids(for now, could be sym adviser for adviser evaluation)
  def get_peer_evaluations_for_self_team_as_hash
    peer_evaluations_hash = {}
    submissions_hash = self.get_own_submissions_as_hash
    milestones = Milestone.all
    milestones.each do |milestone|
      peer_evaluations_hash[milestone.id] = {}
      self.evaluators.each do |evaluator|
        peer_evaluations_hash[milestone.id][evaluator.id] = PeerEvaluation.find_by(submission_id: submissions_hash[milestone.id],
                                                                                   team_id: evaluator.evaluator_id)
      end
      if not self.adviser_id.blank?
        peer_evaluations_hash[milestone.id][:adviser] = PeerEvaluation.find_by(submission_id: submissions_hash[milestone.id],
                                                                               adviser_id: self.adviser_id)
      end
    end
    return peer_evaluations_hash
  end

  # Get average rating for own team based on received evaluations, with milestone_ids are keys
  #   overall evaluating score will be included under special sym :all
  def get_average_rating_for_self_team_as_hash
    ratings_hash = {}
    peer_evaluations_hash = self.get_peer_evaluations_for_self_team_as_hash
    overall_ratings = []
    peer_evaluations_hash.each do |milestone_id, evaluations_hash|
      ratings = []
      evaluations_hash.each do |key, evaluation|
        if not evaluation.nil?
          private_parts = JSON.parse(evaluation.private_content)
          rating = private_parts[Milestone.find(milestone_id).get_overall_rating_question_id]
          if key.is_a? Symbol  # TODO: a temporary solution for testing whether it is from adviser or not
            ratings.append(rating)
            overall_ratings.append(rating)
          end
          ratings.append(rating)
          overall_ratings.append(rating)
        end
      end
      ratings_hash[milestone_id] = get_average_for_ratings(ratings)
    end
    ratings_hash[:all] = get_average_for_ratings(overall_ratings)
    return ratings_hash
  end

  def get_average_for_ratings(ratings)
    sum = 0; numberOfRatings = 0
    ratings.each do |rating|
      if (not rating.nil?) and (rating_num = rating.to_i)
        sum += rating_num; numberOfRatings += 1
      end
    end
    if numberOfRatings == 0
      return nil
    else
      return (sum.to_f / numberOfRatings)
    end
  end

  # Get own feedbacks to evaluator teams as hash, first level of keys are milestone_ids,
  #   second level of keys are evaluating_ids
  # def get_feedbacks_for_evaluator_teams
  #   feedbacks_hash = {}
  #   # TODO: to be implemented
  # end

  # Get a team's members as user
  def get_team_members
    team_members = []
    self.students.each do |student|
      team_members.append(student.user)
    end
    return team_members
  end

  # Get a team's evaluator teams' members as user
  def get_evaluator_teams_members
    evaluator_members = []
    self.evaluators.each do |evaluator|
      evaluator_members.concat(evaluator.evaluator.get_team_members)
    end
    return evaluator_members
  end

  # Get a team's evaluator teams' members as user
  def get_evaluated_teams_members
    evaluated_members = []
    self.evaluateds.each do |evaluated|
      evaluated_members.concat(evaluated.evaluated.get_team_members)
    end
    return evaluated_members
  end
end
