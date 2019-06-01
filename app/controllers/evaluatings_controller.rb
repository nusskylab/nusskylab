# NOTE: Addressing Issue #546 (2017), advisors will be able to map relations between ALL teams.

# EvaluatingsController: manage actions related to evaluatings
#   index:   list of evaluatings
#   new:     view to create an evaluating
#   create:  create an evaluating
#   edit:    edit and evaluating
#   destroy: delete an evaluating
class EvaluatingsController < ApplicationController
  def index
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    cohort = params[:cohort] || current_cohort
    cohort = cohort.to_i
    if current_user_admin? or current_user_adviser?
      @evaluatings = Evaluating.all
    # elsif current_user_adviser?
    #   @evaluatings = Adviser.find_by(
    #     user_id: current_user.id,
    #     cohort: cohort).advised_teams_evaluatings
    else
      fail ActionController::RoutingError, t(
        'application.path_not_found_message')
    end
    @evaluatings = @evaluatings.select do |evaluating|
      evaluating.evaluator.cohort == cohort
    end
    @page_title = t('.page_title')
    render locals: {
      all_cohorts: all_cohorts,
      cohort: cohort
    }
  end

  def new
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    @evaluating = Evaluating.new
    cohort = params[:cohort] || current_cohort
    adviser = Adviser.find_by(user_id: current_user.id, cohort: cohort)
    if current_user_admin? or adviser
      teams = Team.where(cohort: cohort)
    # elsif adviser
    #   teams = adviser.teams.where(cohort: cohort)
    end
    @page_title = t('.page_title')
    render locals: { teams: teams, adviser: adviser}
  end

  def create
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    @evaluating = Evaluating.new(evaluating_params)
    if create_or_update_evaluation_relationship
      redirect_to evaluatings_path, flash: {
        success: t('.success_message',
                   entity1_name: @evaluating.evaluator.team_name,
                   entity2_name: @evaluating.evaluated.team_name)
      }
    else
      redirect_to new_evaluating_path, flash: {
        danger: t('.failure_message',
                  error_message: @evaluating.errors.full_messages.join(', '))
      }
    end
  end

  def edit
    @evaluating = Evaluating.find(params[:id])
    # !authenticate_user(true, false, evaluating_permitted_users) && return
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    cohort = params[:cohort] || current_cohort
    if current_user_admin? or current_user_adviser?
      teams = Team.where(cohort: cohort)
      # teams = Team.all
    # elsif (adviser = current_user_adviser?)
    #   teams = adviser.teams
    end
    @page_title = t('.page_title')
    render locals: { teams: teams }
  end

  def update
    @evaluating = Evaluating.find(params[:id])
    # !authenticate_user(true, false, evaluating_permitted_users) && return
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    @evaluating.assign_attributes(evaluating_params)
    if create_or_update_evaluation_relationship
      redirect_to evaluatings_path, flash: {
        success: t('.success_message',
                   entity1_name: @evaluating.evaluator.team_name,
                   entity2_name: @evaluating.evaluated.team_name)
      }
    else
      redirect_to edit_evaluating_path(@evaluating), flash: {
        danger: t('.failure_message',
                  error_message: @evaluating.errors.full_messages.join(', '))
      }
    end
  end

  def destroy
    @evaluating = Evaluating.find(params[:id])
    # !authenticate_user(true, false, evaluating_permitted_users) && return
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    if @evaluating.destroy
      redirect_to evaluatings_path, flash: {
        success: t('.success_message',
                   entity1_name: @evaluating.evaluator.team_name,
                   entity2_name: @evaluating.evaluated.team_name)
      }
    else
      redirect_to evaluatings_path, flash: {
        danger: t('.failure_message',
                  error_message: @evaluating.errors.full_messages.join(', '))
      }
    end
  end

  private

  def evaluating_params
    params.require(:evaluating).permit(:evaluated_id, :evaluator_id)
  end

  def evaluating_permitted_users
    evaluating_users = []
    adviser = @evaluating.evaluated.adviser
    if adviser and adviser.user_id == current_user.id
      evaluating_users.append(adviser.user)
    end
    evaluating_users
  end

  def create_or_update_evaluation_relationship
    if current_user_admin? or current_user_adviser?
      return @evaluating.save ? @evaluating : nil
    # else
    #   if (@evaluating.evaluated &&
    #       @evaluating.evaluated.adviser.user_id == current_user.id) &&
    #      (@evaluating.evaluator &&
    #       @evaluating.evaluator.adviser.user_id == current_user.id)
    #     return @evaluating.save ? @evaluating : nil
    #   else
    #     @evaluating.errors.add(:evaluated_id, 'User not allowed to do this')
    else
      @evaluating.errors.add(:evaluated_id, 'User not allowed to do this')
    end
    nil
  end
end
