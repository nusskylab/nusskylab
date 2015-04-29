class StudentsController < ApplicationController
  NUS_OPEN_ID_PREFIX = 'https://openid.nus.edu.sg/'
  NUS_OPEN_ID_PROVIDER = 'NUS'

  def index
    @students = Student.all
  end

  def new
    @student = Student.new
  end

  def create
    create_or_update_student_user
    redirect_to students_path
  end

  def batch_upload
    @student = Student.new
  end

  def batch_create
    require 'csv'
    students_csv_file = params[:student][:batch_csv]
    file_rows = CSV.read(students_csv_file.path, headers: true)
    file_rows.each do |row|
      create_student_from_csv_row(row)
    end
    redirect_to students_path
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
  def create_student_from_params(user_params, user2_params, team_params)
    user_params[:provider] = NUS_OPEN_ID_PROVIDER
    user_params[:uid] = NUS_OPEN_ID_PREFIX + user_params[:uid][0, 8]
    if user2_params and team_params
      create_student_with_team(team_params, user2_params, user_params)
    else
      create_student_without_team(user_params)
    end
  end

  def create_student_without_team(user_params)
    user = User.find_by(uid: user_params[:uid],
                        provider: user_params[:provider]) || User.new(user_params)
    if not user.save
      # TODO: deal with this
    end
    student = Student.new(user_id: user.id)
    student.save ? student : nil
  end

  def create_student_with_team(team_params, user2_params, user_params)
    user2_params[:provider] = NUS_OPEN_ID_PROVIDER
    user2_params[:uid] = NUS_OPEN_ID_PREFIX + user2_params[:uid][0, 8]
    user = User.find_by(uid: user_params[:uid],
                        provider: user_params[:provider]) || User.new(user_params)
    if not user.save
      # TODO: deal with this
    end
    user2 = User.find_by(uid: user2_params[:uid],
                         provider: user2_params[:provider]) || User.new(user2_params)
    if not user2.save
      # TODO: deal with this
    end
    if team_params[:project_level][/\ABeginner/]
      team_params[:project_level] = 'Vostok'
    elsif team_params[:project_level][/\AIntermediate/]
      team_params[:project_level] = 'Gemini'
    else
      team_params[:project_level] = 'Apollo 11'
    end
    team = Team.new(team_params)
    if not team.save
      # TODO: deal with this
    end
    student = Student.new(user_id: user.id, team_id: team.id)
    student2 = Student.new(user_id: user2.id, team_id: team.id)
    student.save ? student : nil
    student2.save ? student2 : nil
  end

  def create_student_from_csv_row(row)
    if row[1] == 'As an individual'
      user_params = {}
      user_params[:user_name] = row[2]
      user_params[:email] = row[6]
      user_params[:uid] = row[3]
      create_student_from_params(user_params, nil, nil)
    else
      user1_params = {}
      user2_params = {}
      team_params = {}
      team_params[:team_name] = row[10]
      user1_params[:user_name] = row[11]
      user1_params[:uid] = row[12]
      user1_params[:email] = row[15]
      user2_params[:user_name] = row[16]
      user2_params[:uid] = row [17]
      user2_params[:email] = row[20]
      team_params[:project_level] = row[22]
      create_student_from_params(user1_params, user2_params, team_params)
    end
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
