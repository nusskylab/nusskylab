# QuestionsController: manage actions related to questions
class QuestionsController < ApplicationController
  def create
    !authenticate_user(true, true) && return
    @question = Question.new(question_params)
    if @question.save
      flash[:success] = "Question Created"
    else
      flash[:error] = "Failed to create question"
    end
    render :js => 'window.location.reload()'
  end

  def update
    !authenticate_user(true, true) && return
    @question = Question.find(params[:id]) || (record_not_found && return)
    q_params = question_params
    q_params.except!(:survey_template_id)
    if @question.update(q_params)
      flash[:success] = "Question Updated"
    else
      flash[:error] = "Failed to update question"
    end
    render :js => 'window.location.reload()'
  end

  def destroy
    !authenticate_user(true, true) && return
    @question = Question.find(params[:id])
    if @question.destroy
      flash[:success] = "Question Deleted"
    else
      flash[:error] = "Failed to delete question"
    end
    render :js => 'window.location.reload()'
  end

  private

  def question_params
    q_params = params.require(:question).permit(:question_type, :title,
                                                :is_public, :order,
                                                :instruction, :content, :extras,
                                                :survey_template_id)
    q_params[:question_type] = q_params[:question_type].to_i
    q_params
  end
end
