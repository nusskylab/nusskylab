class EvaluatingsController < ApplicationController
  def index
    @evaluatings = Evaluating.all
  end

  def new
    @evaluating = Evaluating.new
  end

  def create
    @evaluating = create_or_update_evaluation_relationship
    redirect_to evaluatings_path
  end

  def show
  end

  private
  def create_or_update_evaluation_relationship
    evaluated_id = params[:evaluated_id]
    evaluator_id = params[:evaluator_id]
    evaluating = Evaluating.new(evaluated_id: evaluated_id, evaluator_id: evaluator_id)
    evaluating.save
    evaluating
  end
end
