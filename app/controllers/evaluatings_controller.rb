class EvaluatingsController < ApplicationController
  layout 'admins'

  def index
    not check_access(true, true) and return
    @evaluatings = Evaluating.all
  end

  def new
    not check_access(true, true) and return
    @evaluating = Evaluating.new
    render locals: {
             teams: Team.all
           }
  end

  def create
    not check_access(true, true) and return
    evaluating = create_evaluation_relationship
    if evaluating
      redirect_to evaluatings_path
    else
      render 'new', locals: {
               teams: Team.all
                  }
    end
  end

  def edit
    not check_access(true, true) and return
    @evaluating = Evaluating.find(params[:id])
    render locals: {
             teams: Team.all
           }
  end

  def update
    not check_access(true, true) and return
    evaluating = update_evaluation_relationship
    if evaluating
      redirect_to evaluatings_path
    else
      render 'edit', locals: {
                    teams: Team.all
                  }
    end
  end

  def destroy
    not check_access(true, true) and return
    evaluating = Evaluating.find(params[:id])
    evaluating.destroy if evaluating
    redirect_to evaluatings_path
  end

  private
  def get_evaluating_params
    evaluating_params = params.require(:evaluating).permit(:evaluated_id, :evaluator_id)
  end

  def create_evaluation_relationship
    @evaluating = Evaluating.new(get_evaluating_params)
    @evaluating.save ? @evaluating : nil
  end

  def update_evaluation_relationship
    @evaluating = Evaluating.find(params[:id])
    (@evaluating and @evaluating.update(get_evaluating_params)) ? @evaluating : nil
  end
end
