# ReceivedEvalsController: manage actions related to received_evals
#   index: list of all the evaluations received
class ReceivedEvalsController < ApplicationController
  def index
    team = Team.find(params[:team_id])
    milestone = Milestone.find(params[:milestone_id])
    !authenticate_user(true, false, team.get_relevant_users(false, false)) &&
      return
    @page_title = t('.page_title')
    evaluators = team.evaluators
    evaluator_names = []
    team_evaluations_table = {}
    team_submission = Submission.find_by(team_id: team.id,
                                         milestone_id: milestone.id)
    populate_evaluations_for_team(evaluator_names, evaluators, team,
                                  team_evaluations_table, team_submission)
    render locals: {
      team: team,
      evaluators: evaluators,
      evaluator_names: evaluator_names,
      milestone: milestone,
      survey_template: SurveyTemplate.find_by(
        milestone_id: params[:milestone_id], survey_type: 1),
      team_evaluations_table: team_evaluations_table
    }
  end

  private

  def populate_evaluations_for_team(evaluator_names, evaluators, team,
                                    team_evaluations_table, team_submission)
    if team_submission
      evaluators.each do |evaluator|
        evaluator_name = 'Team: ' + evaluator.evaluator.team_name
        evaluator_names.append(evaluator_name)
        team_evaluations_table[evaluator_name] = PeerEvaluation.find_by(
          team_id: evaluator.evaluator_id,
          submission_id: team_submission.id)
      end
      evaluator_name = 'Adviser: ' + team.adviser.user.user_name
      evaluator_names.append(evaluator_name)
      team_evaluations_table[evaluator_name] = PeerEvaluation.find_by(
        adviser_id: team.adviser_id,
        submission_id: team_submission.id)
    end
  end
end
