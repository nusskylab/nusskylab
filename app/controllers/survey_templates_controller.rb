# SurveyTemplatesController: manage actions related to survey_templates
#   index:  list all survey_templates
#   new:    view to create a survey template
#   create: create a survey template
#   edit:   view to edit a survey template
#   update: update a survey template
#   show:   display survey_template and questions
class SurveyTemplatesController < ApplicationController
  def index
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    @survey_templates = SurveyTemplate.all.order(:milestone_id)
  end

  def new
    !authenticate_user(true, true) && return
    @survey_template = SurveyTemplate.new
    @page_title = t('.page_title')
    render locals: {
      milestones: Milestone.all
    }
  end

  def create
    !authenticate_user(true, true) && return
    @survey_template = SurveyTemplate.new(survey_template_params)
    if @survey_template.save
      redirect_to survey_templates_path, flash: {
        success: t('.success_message')
      }
    else
      error_message = @survey_template.errors.full_messages.join(', ')
      redirect_to new_survey_template_path, flash: {
        success: t('.failure_message',
                   error_message: error_message)
      }
    end
  end

  def edit
    !authenticate_user(true, true) && return
    @survey_template = SurveyTemplate.find(params[:id])
    @page_title = t('.page_title')
    render locals: {
      milestones: Milestone.all
    }
  end

  def update
    !authenticate_user(true, true) && return
    @survey_template = SurveyTemplate.find(params[:id])
    if @survey_template.update(survey_template_params)
      redirect_to survey_templates_path, flash: {
        success: t('.success_message')
      }
    else
      error_message = @survey_template.errors.full_messages.join(', ')
      redirect_to edit_survey_template_path(@survey_template), flash: {
        success: t('.failure_message',
                   error_message: error_message)
      }
    end
  end

  def show
    !authenticate_user(true, true) && return
    @survey_template = SurveyTemplate.find(params[:id])
    @page_title = t('.page_title')
    render locals: {
      new_question: Question.new(survey_template_id: @survey_template.id)
    }
  end

  private

  def survey_template_params
    st_params = params.require(:survey_template).permit(:milestone_id,
                                                        :survey_type,
                                                        :instruction,
                                                        :deadline)
    st_params[:survey_type] = st_params[:survey_type].to_i
    st_params
  end
end
