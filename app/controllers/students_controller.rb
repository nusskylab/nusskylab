class StudentsController < ApplicationController
  NUS_OPEN_ID_PREFIX = 'https://openid.nus.edu.sg/'
  NUS_OPEN_ID_PROVIDER = 'NUS'

  def index
    @students = Student.all
  end

  def create
    create_or_update_student_user
    redirect_to students_path
  end

  def new
    @student = Student.new
    render locals: {
             batch_csv: ''
           }
  end

  def edit
    @student = Student.find(params[:id])
  end

  def show
    @student = Student.find(params[:id])
    evaluateds, evaluators, milestones, team_evaluateds_submissions_table, team_evaluations_table, team_evaluators_evaluations_table, team_submissions_table = get_render_variable_for_student
    render locals: {
             milestones: milestones,
             evaluateds: evaluateds,
             evaluators: evaluators,
             team_submissions: team_submissions_table,
             team_evaluateds_submissions: team_evaluateds_submissions_table,
             team_evaluations: team_evaluations_table,
             team_evaluators_evaluations: team_evaluators_evaluations_table
           }
  end

  def update
    create_or_update_student_user
    redirect_to students_path
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to students_path
  end

  private
  def create_or_update_student_user
    if params[:batch_creation]
      require 'csv'
      batch_csv = params[:batch_csv]
      CSV.foreach(batch_csv, {col_sep: "\t", headers: true}) do |row|
        puts row
      end
    else
      uid = NUS_OPEN_ID_PREFIX + params[:nus_id]
      provider = NUS_OPEN_ID_PROVIDER
      email = params[:user_email]
      user_name = params[:user_name]
      user = User.create_or_update_by_provider_and_uid(uid: uid,
                                                       provider: provider,
                                                       email: email,
                                                       user_name: user_name)
      team_name = params[:team_name]
      project_title = params[:project_title]
      project_level = params[:project_level]
      student = Student.create_or_update_by_user_id(user_id: user.id,
                                                    team_name: team_name,
                                                    project_title: project_title,
                                                    project_level: project_level)
    end
    return student
  end

  def get_render_variable_for_student
    milestones = Milestone.all
    team_submissions_table = {}
    team_evaluateds_submissions_table = {}
    team_evaluations_table = {}
    team_evaluators_evaluations_table = {}
    evaluateds = []
    evaluators = []
    if @student.team_id
      evaluateds, evaluators, milestones, team_evaluateds_submissions_table, team_evaluations_table, team_evaluators_evaluations_table, team_submissions_table = get_additional_render_variables_for_student_with_team(milestones)
    end
    return evaluateds, evaluators, milestones, team_evaluateds_submissions_table, team_evaluations_table, team_evaluators_evaluations_table, team_submissions_table
  end

  def get_additional_render_variables_for_student_with_team(milestones)
    team_submissions_table = {}
    team_evaluateds_submissions_table = {}
    team_evaluations_table = {}
    team_evaluators_evaluations_table = {}
    evaluateds = @student.team.evaluateds
    evaluators = @student.team.evaluators
    milestones.each do |milestone|
      team_evaluateds_submissions_table[milestone.id] = {}
      team_evaluators_evaluations_table[milestone.id] = {}
      team_evaluations_table[milestone.id] = {}
      evaluateds.each do |evaluated|
        temp_evaluated_submission = Submission.find_by(team_id: evaluated.evaluated_id, milestone_id: milestone.id)
        if temp_evaluated_submission
          team_evaluateds_submissions_table[milestone.id][evaluated.evaluated_id] = temp_evaluated_submission
          team_evaluations_table[milestone.id][evaluated.evaluated_id] = PeerEvaluation.find_by(team_id: @student.team_id,
                                                                                                submission_id: temp_evaluated_submission.id)
        end
      end
      temp_team_submission = Submission.find_by(team_id: @student.team_id, milestone_id: milestone.id)
      if temp_team_submission
        team_submissions_table[milestone.id] = temp_team_submission
        evaluators.each do |evaluator|
          team_evaluators_evaluations_table[milestone.id][evaluator.evaluator_id] = PeerEvaluation.find_by(team_id: evaluator.evaluator_id,
                                                                                                           submission_id: temp_team_submission.id)
        end
      end
    end
    return evaluateds, evaluators, milestones, team_evaluateds_submissions_table, team_evaluations_table, team_evaluators_evaluations_table, team_submissions_table
  end
end
