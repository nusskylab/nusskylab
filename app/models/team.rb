# Team: team modeling
class Team < ActiveRecord::Base
  include ModelHelper
  validates :team_name, presence: true, uniqueness: {
    scope: :cohort,
    message: ': Team name should be unique'
  }
  before_validation :fill_current_cohort

  belongs_to :adviser
  belongs_to :mentor
  has_many :students, dependent: :nullify
  has_many :submissions, dependent: :destroy
  has_many :peer_evaluations, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :evaluateds, class_name: :Evaluating, foreign_key: :evaluator_id
  has_many :evaluators, class_name: :Evaluating, foreign_key: :evaluated_id

  VOSTOK_REGEX = /\A(?:v)|(?:vostok)\z/
  PROJECT_GEMINI_REGEX = /\A(?:project gemini)|(?:gemini)|(?:g)\z/
  APOLLO_11_REGEX = /\A(?:apollo 11)|(?:apollo)|(?:a)\z/
  enum project_level: [:vostok, :project_gemini, :apollo_11]

  def self.to_csv(**options)
    require 'csv'
    if options[:cohort].nil?
      exported_teams = all
    else
      exported_teams = where(cohort: options[:cohort])
      options.delete(:cohort)
    end
    CSV.generate(options) do |csv|
      csv << Team.generate_csv_header_row
      exported_teams.each do |team|
        csv << team.to_csv_row
      end
    end
  end

  def self.generate_csv_header_row
    ['Team ID', 'Team Name', 'Project Level', 'Has Dropped', 'Student 1 UserID',
     'Student 1 Name', 'Student 1 Email', 'Student 2 UserID', 'Student 2 Name',
     'Student 2 Email', 'Adviser UserID', 'Adviser Name', 'Mentor UserID',
     'Mentor Name', 'Average PE Score']
  end

  def to_csv_row
    csv_row = [id, team_name, get_project_level, has_dropped]
    export_add_team_members(csv_row)
    export_adviser_and_mentor(csv_row)
    ratings_hash = get_average_evaluation_ratings
    csv_row.append(ratings_hash[:all])
    csv_row
  end

  def export_add_team_members(csv_row)
    members_data = []
    members = get_team_members
    members.each do |member_user|
      members_data.concat([member_user.id, member_user.user_name,
                           member_user.email])
    end
    members_data.concat(%w(nil nil nil)) if members_data.length < 6
    csv_row.concat(members_data)
    csv_row
  end

  def export_adviser_and_mentor(csv_row)
    if !adviser_id.blank?
      csv_row.concat([adviser.user.id, adviser.user.user_name])
    else
      csv_row.concat(%w(nil nil))
    end
    if !mentor_id.blank?
      csv_row.concat([mentor.user.id, mentor.user.user_name])
    else
      csv_row.concat(%w(nil nil))
    end
    csv_row
  end

  def self.get_project_level_from_raw(plevel)
    project_level = plevel.downcase
    if project_level[VOSTOK_REGEX]
      Team.project_levels[:vostok]
    elsif project_level[PROJECT_GEMINI_REGEX]
      Team.project_levels[:project_gemini]
    elsif project_level[APOLLO_11_REGEX]
      Team.project_levels[:apollo_11]
    end
  end

  def set_project_level(plevel)
    self.project_level = Team.get_project_level_from_raw(plevel)
  end

  def get_project_level
    project_level.gsub(/_/, ' ').split(' ').map(&:capitalize).join(' ')
  end

  def get_relevant_users(include_evaluator = false, include_evaluated = false)
    relevant_users = get_team_members
    relevant_users.append(adviser.user) unless adviser_id.blank?
    relevant_users.append(mentor.user) unless mentor_id.blank?
    relevant_users.concat(get_evaluator_teams_members) if include_evaluator
    relevant_users.concat(get_evaluated_teams_members) if include_evaluated
    relevant_users
  end

  def get_own_submissions
    submissions_hash = {}
    submissions.each do |submission|
      submissions_hash[submission.milestone_id] = submission
    end
    submissions_hash
  end

  def get_others_submissions
    evaluated_submissions = {}
    milestones = Milestone.all
    milestones.each do |milestone|
      evaluated_submissions[milestone.id] = {}
      evaluateds.each do |evaluated|
        evaluated_submissions[milestone.id][evaluated.id] = Submission.find_by(
          team_id: evaluated.evaluated_id,
          milestone_id: milestone.id)
      end
    end
    evaluated_submissions
  end

  def get_own_evaluations_for_others
    own_evaluations = {}
    peer_evaluations.each do |evaluation|
      own_evaluations[evaluation.submission_id] = evaluation
    end
    own_evaluations
  end

  def get_evaluations_for_own_team
    peer_evas = {}
    submissions_hash = get_own_submissions
    milestones = Milestone.all
    milestones.each do |milestone|
      peer_evas[milestone.id] = {}
      evaluators.each do |evaluator|
        peer_evas[milestone.id][evaluator.id] = PeerEvaluation.find_by(
          submission_id: submissions_hash[milestone.id],
          team_id: evaluator.evaluator_id)
      end
      peer_evas[milestone.id][:adviser] = PeerEvaluation.find_by(
        submission_id: submissions_hash[milestone.id],
        adviser_id: adviser_id) unless adviser_id.blank?
    end
    peer_evas
  end

  def get_feedbacks_for_others
    feedbacks_hash = {}
    evaluators.each do |evaluator|
      feedbacks_hash[evaluator.id] = Feedback.find_by(
        team_id: id, target_team_id: evaluator.evaluator_id)
    end
    feedbacks_hash
  end

  def get_average_evaluation_ratings
    ratings_hash = {}
    peer_evaluations_hash = get_evaluations_for_own_team
    overall_ratings = []
    peer_evaluations_hash.each do |milestone_id, evaluations_hash|
      ratings = []
      evaluations_hash.each do |key, evaluation|
        if !evaluation.nil? && !evaluation.private_content.nil?
          private_parts = JSON.parse(evaluation.private_content)
          rating = private_parts[Milestone.find(
            milestone_id).get_overall_rating_question_id].to_i
          # TODO: a temporary solution for testing whether it is from adviser
          #   or not
          if key.is_a? Symbol
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
    ratings_hash
  end

  def get_average_feedback_ratings
    recv_feedbacks = Feedback.where(target_team_id: id)
    ratings = []
    recv_feedbacks.each do |feedback|
      ratings.append(feedback.get_response_for_question(1).to_i)
    end
    { all: get_average_for_ratings(ratings) }
  end

  def get_average_for_ratings(ratings)
    sum = ratings.reduce(:+)
    (sum.to_f / ratings.length) if ratings.length > 0
  end

  def get_team_members
    students.map(&:user)
  end

  def invitor_student
    students.each do |stu|
      return stu if stu.id == invitor_student_id
    end
    nil
  end

  def invitee_student
    students.each do |stu|
      return stu if stu.id != invitor_student_id
    end
    nil
  end

  def get_evaluator_teams_members
    evaluator_members = []
    evaluators.each do |evaluator|
      evaluator_members.concat(evaluator.evaluator.get_team_members)
    end
    evaluator_members
  end

  def get_evaluated_teams_members
    evaluated_members = []
    evaluateds.each do |evaluated|
      evaluated_members.concat(evaluated.evaluated.get_team_members)
    end
    evaluated_members
  end
end
