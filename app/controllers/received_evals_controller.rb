class ReceivedEvalsController < ApplicationController
  layout 'general_layout'

  def index
    team = Team.find(params[:team_id])
    received_evals_access_strategy = lambda {
      loggedin_user = current_user
      if @team.adviser and @team.adviser.user_id == loggedin_user.id
        return true
      end
      if @team.mentor and @team.mentor.user_id == loggedin_user.id
        return true
      end
      students = @team.students
      is_student = false
      students.each do |student|
        if student.user_id == loggedin_user.id
          is_student = true
          break
        end
      end
      if is_student
        return true
      end
      evaluateds_and_evaluators = []
      @team.evaluateds.each do |evaluated|
        evaluateds_and_evaluators.concat(evaluated.evaluated.students)
      end
      @team.evaluators.each do |evaluator|
        evaluateds_and_evaluators.concat(evaluator.evaluator.students)
      end
      has_evaluating_relation = false
      evaluateds_and_evaluators.each do |eval_er|
        if eval_er.user_id == loggedin_user.id
          has_evaluating_relation = true
          break
        end
      end
      if has_evaluating_relation
        return true
      end
      return false
    }
    not check_access(true, false, received_evals_access_strategy) and return
    evaluators = team.evaluators
    evaluator_names = []
    milestone = Milestone.find(params[:milestone_id])
    if milestone.peer_evaluation_deadline > Time.now
      flash = {}
      flash[:danger] = 'Please view received evaluations after deadline for evaluation submission'
      redirect_to root_url, flash: flash
    end
    team_evaluations_table = {}
    team_submission = Submission.find_by(team_id: team.id,
                                         milestone_id: milestone.id)
    populate_evaluations_for_team(evaluator_names, evaluators, team, team_evaluations_table, team_submission)
    render locals: {
             team: team,
             evaluators: evaluators,
             evaluator_names: evaluator_names,
             milestone: milestone,
             team_evaluations_table: team_evaluations_table
           }
  end

  def populate_evaluations_for_team(evaluator_names, evaluators, team, team_evaluations_table, team_submission)
    if team_submission
      evaluators.each do |evaluator|
        evaluator_name = 'Team: ' + evaluator.evaluator.team_name
        evaluator_names.append(evaluator_name)
        team_evaluations_table[evaluator_name] = PeerEvaluation.find_by(team_id: evaluator.evaluator_id,
                                                                        submission_id: team_submission.id)
      end
      evaluator_name = 'Adviser: ' + team.adviser.user.user_name
      evaluator_names.append(evaluator_name)
      team_evaluations_table[evaluator_name] = PeerEvaluation.find_by(adviser_id: team.adviser_id,
                                                                      submission_id: team_submission.id)
    end
  end

  def get_home_link
    team = Team.find(params[:team_id])
    team ? team_path(team) : '/'
  end

  def get_page_title
    @page_title = @page_title || 'Received Evaluations | Orbital'
    super
  end
end
