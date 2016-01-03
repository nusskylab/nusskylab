# QuestionsController: manage actions related to questions
class QuestionsController < ApplicationController
  def create
    !authenticate_user(true, true) && return
    puts params
    @question = Question.new(question_params)
    if @question.save
      render 'question_response', layout: false, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def update
    !authenticate_user(true, true) && return
    @question = Question.find(params[:id])
    q_params = question_params
    q_params.except!(:survey_template_id)
    if @question.update(q_params)
      render 'question_response', layout: false, status: :ok
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    !authenticate_user(true, true) && return
    puts params
  end

  private

  def question_params
    q_params = params.require(:question).permit(:question_type, :title,
                                                :instruction, :content,
                                                :survey_template_id)
    q_params[:question_type] = q_params[:question_type].to_i
    q_params
  end
end
