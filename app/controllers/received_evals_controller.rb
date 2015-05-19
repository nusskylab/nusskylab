class ReceivedEvalsController < ApplicationController
  layout 'general_layout'

  def index
    team = Team.find(params[:team_id])
    evaluators = team.evaluators
    milestone = Milestone.find(params[:milestone_id])
    team_evaluation_table = {}
    temp_team_submission = Submission.find_by(team_id: team.id, milestone_id: milestone.id)
    if temp_team_submission
      evaluators.each do |evaluator|
        team_evaluation_table[evaluator.evaluator_id] = PeerEvaluation.find_by(team_id: evaluator.evaluator_id,
                                                                               submission_id: temp_team_submission.id)
      end
    end
    render locals: {
             team: team,
             evaluators: evaluators,
             milestone: milestone,
             team_evaluation_table: team_evaluation_table
           }
  end

  def get_home_link
    team = Team.find(params[:team_id])
    team ? team_path(team) : '/'
  end
end
