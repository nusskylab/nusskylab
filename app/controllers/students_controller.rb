class StudentsController < ApplicationController
  NUS_OPEN_ID_PREFIX = 'https://openid.nus.edu.sg/'
  NUS_OPEN_ID_PROVIDER = 'NUS'

  layout 'general_layout'

  def index
    not check_access(true, true) and return
    @students = Student.all
    render layout: 'admins'
  end

  def new
    not check_access(true, true) and return
    @student = Student.new
    render layout: 'admins', locals: {
                             users: User.all
                           }
  end

  def create
    not check_access(true, true) and return
    user_params = get_user_params
    user = User.new(user_params)
    if user.save
      create_student_for_user_and_respond(user)
    else
      render_new_template
    end
  end

  def batch_upload
    not check_access(true, true) and return
    @student = Student.new
  end

  def batch_create
    not check_access(true, true) and return
    require 'csv'
    students_csv_file = params[:student][:batch_csv]
    file_rows = CSV.read(students_csv_file.path, headers: true)
    file_rows.each do |row|
      create_student_from_csv_row(row)
    end
    redirect_to students_path
  end

  def use_existing
    not check_access(true, true) and return
    user = User.find(params[:student][:user_id])
    if user
      create_student_for_user_and_respond(user)
    else
      render_new_template
    end
  end

  def edit
    not check_access(true, true) and return
    @student = Student.find(params[:id])
    render layout: 'admins', locals: {
             teams: Team.all
                           }
  end

  def show
    @student = Student.find(params[:id])
    display_student_access_strategy = lambda {
      if @student.user_id == current_user.id
        return true
      end
      if @student.team_id.nil?
        return false
      else
        if @student.team.adviser and @student.team.adviser.user_id == current_user.id
          return true
        end
        @student.get_teammates.each do |teammate|
          if teammate.user_id == current_user.id
            return true
          end
        end
        return false
      end
    }
    not check_access(true, false, display_student_access_strategy) and return
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
    not check_access(true, true) and return
    @student = Student.find(params[:id])
    student_params = params.require(:student).permit(:team_id)
    if @student.update(student_params)
      redirect_to @student
    else
      render layout: 'admins', template: 'students/edit', locals: {
               teams: Team.all
                             }
    end
  end

  def destroy
    not check_access(true, false) and return
    @student = Student.find(params[:id])
    @student.destroy
    redirect_to students_path
  end

  def get_page_title
    @page_title = @page_title || 'Students | Orbital'
    super
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
        print(user_params)
      end
      student = Student.new(user_id: user.id)
      if not student.save
        print(user_params)
      else
        student
      end
    end

    def create_student_with_team(team_params, user2_params, user_params)
      user2_params[:provider] = NUS_OPEN_ID_PROVIDER
      user2_params[:uid] = NUS_OPEN_ID_PREFIX + user2_params[:uid][0, 8]
      user = User.find_by(uid: user_params[:uid],
                          provider: user_params[:provider]) || User.new(user_params)
      if not user.save
        # TODO: deal with this
        print(user_params)
      end
      user2 = User.find_by(uid: user2_params[:uid],
                           provider: user2_params[:provider]) || User.new(user2_params)
      if not user2.save
        # TODO: deal with this
        print(user2_params)
      end
      set_team_params_project_level(team_params)
      team = Team.new(team_params)
      if not team.save
        # TODO: deal with this
      end
      student = Student.new(user_id: user.id, team_id: team.id)
      student2 = Student.new(user_id: user2.id, team_id: team.id)
      if not student.save
        print(user_params)
      else
        student
      end
      if not student2.save
        print(user2_params)
      else
        student2
      end
    end

    def set_team_params_project_level(team_params)
      if team_params[:project_level][/\ABeginner/]
        team_params[:project_level] = 'Vostok'
      elsif team_params[:project_level][/\AIntermediate/]
        team_params[:project_level] = 'Gemini'
      else
        team_params[:project_level] = 'Apollo 11'
      end
    end

    def create_student_from_csv_row(row)
      if row[1] == 'As an individual'
        user_params = extract_user_without_team(row)
        create_student_from_params(user_params, nil, nil)
      else
        team_params, user1_params, user2_params = extract_users_and_team_info(row)
        create_student_from_params(user1_params, user2_params, team_params)
      end
    end

    def extract_user_without_team(row)
      user_params = {}
      user_params[:user_name] = row[2]
      user_params[:email] = row[5]
      user_params[:uid] = row[3]
      user_params
    end

    def extract_users_and_team_info(row)
      user1_params = {}
      user2_params = {}
      team_params = {}
      team_params[:team_name] = row[10]
      user1_params[:user_name] = row[11]
      user1_params[:uid] = row[12]
      user1_params[:email] = row[14]
      user2_params[:user_name] = row[16]
      user2_params[:uid] = row [17]
      user2_params[:email] = row[19]
      team_params[:project_level] = row[22]
      return team_params, user1_params, user2_params
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
        evaluateds, evaluators,
          milestones, team_evaluateds_submissions_table,
          team_evaluations_table, team_evaluators_evaluations_table,
          team_submissions_table = get_additional_render_variables_for_student_with_team(milestones)
      end
      return evaluateds, evaluators, milestones,
        team_evaluateds_submissions_table, team_evaluations_table,
        team_evaluators_evaluations_table, team_submissions_table
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
      return evaluateds, evaluators, milestones,
        team_evaluateds_submissions_table, team_evaluations_table,
        team_evaluators_evaluations_table, team_submissions_table
    end

    def get_user_params
      user_param = params.require(:user).permit(:user_name, :email, :uid, :provider)
    end

    def create_student_for_user_and_respond(user)
      @student = Student.new(user_id: user.id)
      if @student.save
        redirect_to students_path
      else
        render_new_template
      end
    end

    def render_new_template
      render layout: 'admins', template: 'students/new', locals: {
                    users: User.all
                  }
    end
end
