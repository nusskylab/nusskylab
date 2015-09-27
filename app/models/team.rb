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

  def self.to_csv(**options)
    require 'csv'
    CSV.generate(options) do |csv|
      csv << ['Team ID', 'Team Name', 'Project Level', 'Has Dropped', 'Student 1 UserID',
              'Student 1 Name', 'Student 1 Email', 'Student 2 UserID', 'Student 2 Name',
              'Student 2 Email', 'Adviser UserID', 'Adviser Name', 'Mentor UserID', 'Mentor Name',
              'Average PE Score']
      all.each do |team|
        csv_row = [team.id, team.team_name, team.project_level, team.has_dropped]
        team.send :export_add_team_members, csv_row
        team.send :export_adviser_and_mentor, csv_row
        ratings_hash = team.get_average_evaluation_ratings
        csv_row.append(ratings_hash[:all])
        csv << csv_row
      end
    end
  end

  def self.get_project_level_from_raw(project_level)
    project_level = project_level.downcase
    if project_level[VOSTOK_REGEX]
      Team.project_levels[:vostok]
    elsif project_level[PROJECT_GEMINI_REGEX]
      Team.project_levels[:project_gemini]
    elsif project_level[APOLLO_11_REGEX]
      Team.project_levels[:apollo_11]
    end
  end

  def set_project_level(project_level)
    self.project_level = Team.get_project_level_from_raw(project_level)
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
  def get_own_submissions
    submissions_hash = {}
    self.submissions.each do |submission|
      submissions_hash[submission.milestone_id] = submission
    end
    return submissions_hash
  end

  # Get team's evaluated teams' submissions as hash,
  #   first level of keys are milestone_id
  #   second level of keys are evaluating_id
  def get_others_submissions
    evaluated_submissions = {}
    milestones = Milestone.all
    milestones.each do |milestone|
      evaluated_submissions[milestone.id] = {}
      self.evaluateds.each do |evaluated|
        evaluated_submissions[milestone.id][evaluated.id] = Submission.find_by(team_id: evaluated.evaluated_id,
                                                                               milestone_id: milestone.id)
      end
    end
    return evaluated_submissions
  end

  # Get own peer evaluations as hash with evaluated teams' submission ids as keys
  def get_own_evaluations_for_others
    own_evaluations = {}
    self.peer_evaluations.each do |evaluation|
      own_evaluations[evaluation.submission_id] = evaluation
    end
    own_evaluations
  end

  # Get peer evaluations for self as hash, first level of keys are milestone_ids
  #   second level of keys are evaluating_ids(for now, could be sym adviser for adviser evaluation)
  def get_evaluations_for_own_team
    peer_evaluations_hash = {}
    submissions_hash = self.get_own_submissions
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

  def get_feedbacks_for_others
    feedbacks_hash = {}
    self.evaluators.each do |evaluator|
      feedbacks_hash[evaluator.id] = Feedback.find_by(team_id: self.id, target_team_id: evaluator.evaluator_id)
    end
    feedbacks_hash
  end

  # Get average rating for own team based on received evaluations, with milestone_ids are keys
  #   overall evaluating score will be included under special sym :all
  def get_average_evaluation_ratings
    ratings_hash = {}
    peer_evaluations_hash = self.get_evaluations_for_own_team
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

  # Get average ratings for feedback. Currently there is only overall option
  def get_average_feedback_ratings
    recv_feedbacks = Feedback.where(target_team_id: self.id)
    ratings = []
    recv_feedbacks.each do |feedback|
      response = feedback.get_response_for_question(1).nil? ? 0 : feedback.get_response_for_question(1).to_i
      ratings.append(response)
    end
    {:all => get_average_for_ratings(ratings)}
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

  private
  def export_add_team_members(csv_row)
    members = self.get_team_members
    members.each do |member_user|
      csv_row.concat([member_user.id, member_user.user_name, member_user.email])
    end
    csv_row
  end

  def export_adviser_and_mentor(csv_row)
    if not self.adviser_id.blank?
      csv_row.concat([self.adviser.user.id, self.adviser.user.user_name])
    else
      csv_row.concat(%w(nil nil))
    end
    if not self.mentor_id.blank?
      csv_row.concat([self.mentor.user.id, self.mentor.user.user_name])
    else
      csv_row.concat(%w(nil nil))
    end
    csv_row
  end
end
