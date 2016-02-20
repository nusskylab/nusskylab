# AdvisersController: manage actions related to advisers
#   index:   list all advisers
#   new:     view to create an adviser
#   create:  create an adviser
#   show:    view of an adviser
#   destroy: delete an adviser
class AdvisersController < ApplicationController
  def index
    !authenticate_user(true, true) && return
    cohort = params[:cohort] || current_cohort
    @page_title = t('.page_title')
    @advisers = Adviser.where(cohort: cohort)
    respond_to do |format|
      format.html { render }
      format.csv { send_data Adviser.to_csv }
    end
  end

  def new
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    @adviser = Adviser.new
    render locals: { users: User.all }
  end

  def create
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    user = User.find(params[:adviser][:user_id])
    @adviser = Adviser.new(user_id: user.id)
    redirect_after_create_action(user.user_name)
  end

  def show
    @adviser = Adviser.find(params[:id])
    !authenticate_user(true, false, [@adviser.user]) && return
    @page_title = t('.page_title', user_name: @adviser.user.user_name)
    milestones, teams_submissions, own_evaluations = data_for_adviser
    render locals: {
      milestones: milestones,
      teams_submissions: teams_submissions,
      own_evaluations: own_evaluations
    }
  end

  def destroy
    !authenticate_user(true, true) && return
    @adviser = Adviser.find(params[:id])
    redirect_after_destroy_action
  end

  private

  def redirect_after_create_action(user_name)
    if @adviser.save
      redirect_to advisers_path, flash: {
        success: t('.success_message', user_name: user_name)
      }
    else
      redirect_to new_adviser_path, flash: {
        danger: t('.failure_message',
                  error_message: @adviser.errors.full_messages.join(' '))
      }
    end
  end

  def redirect_after_destroy_action
    if @adviser.destroy
      redirect_to advisers_path, flash: {
        success: t('.success_message', user_name: @adviser.user.user_name)
      }
    else
      redirect_to advisers_path, flash: {
        danger: t('.failure_message',
                  error_message: @adviser.errors.full_messages.join(' '))
      }
    end
  end

  # TODO: refactor this method to shorten this
  def data_for_adviser
    milestones = Milestone.all
    teams_submissions = {}
    own_evaluations = {}
    milestones.each do |milestone|
      teams_submissions[milestone.id] = {}
      own_evaluations[milestone.id] = {}
      @adviser.teams.each do |team|
        team_sub = Submission.find_by(milestone_id: milestone.id,
                                      team_id: team.id)
        teams_submissions[milestone.id][team.id] = team_sub
        next if team_sub.nil?
        own_evaluations[milestone.id][team.id] =
          PeerEvaluation.find_by(submission_id: team_sub.id,
                                 adviser_id: @adviser.id)
      end
    end
    return milestones, teams_submissions, own_evaluations
  end
end
