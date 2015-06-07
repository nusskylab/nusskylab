class ReceivedEvalsController < ApplicationController
  layout 'general_layout'

  def index
    team = Team.find(params[:team_id])
    evaluators = team.evaluators
    evaluator_names = []
    milestone = Milestone.find(params[:milestone_id])
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
