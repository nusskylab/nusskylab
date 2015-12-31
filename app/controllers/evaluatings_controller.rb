# EvaluatingsController: manage actions related to evaluatings
#   index:   list of evaluatings
#   new:     view to create an evaluating
#   create:  create an evaluating
#   edit:    edit and evaluating
#   destroy: delete an evaluating
class EvaluatingsController < ApplicationController
  def index
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    if current_user_admin?
      @evaluatings = Evaluating.all
    elsif current_user_adviser?
      @evaluatings = Adviser.adviser?(current_user.id).advised_teams_evaluatings
    else
      fail ActionController::RoutingError, t('application.path_not_found_message')
    end
    @page_title = t('.page_title')
  end

  def new
    !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    @evaluating = Evaluating.new
    adviser = Adviser.adviser?(current_user.id)
    if current_user_admin?
      teams = Team.all
    elsif adviser
      teams = adviser.teams
    end
    @page_title = t('.page_title')
    render locals: { teams: teams }
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
    !authenticate_user(true, false, evaluating_permitted_users) && return
    if current_user_admin?
      teams = Team.all
    elsif (adviser = current_user_adviser?)
      teams = adviser.teams
    end
    @page_title = t('.page_title')
    render locals: { teams: teams }
  end

  def update
    @evaluating = Evaluating.find(params[:id])
    !authenticate_user(true, false, evaluating_permitted_users) && return
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
    !authenticate_user(true, false, evaluating_permitted_users) && return
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
    adviser = Adviser.adviser?(current_user.id) if current_user
    if adviser && @evaluating.evaluated.adviser_id == adviser.id
      evaluating_users.append(adviser.user)
    end
    evaluating_users
  end

  def create_or_update_evaluation_relationship
    adviser = Adviser.adviser?(current_user.id)
    if current_user_admin?
      return @evaluating.save ? @evaluating : nil
    elsif !adviser.nil?
      if (@evaluating.evaluated &&
          @evaluating.evaluated.adviser_id == adviser.id) &&
         (@evaluating.evaluator &&
          @evaluating.evaluator.adviser_id == adviser.id)
        return @evaluating.save ? @evaluating : nil
      end
    end
    nil
  end
end
