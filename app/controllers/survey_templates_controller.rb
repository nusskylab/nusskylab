class SurveyTemplatesController < ApplicationController
  def index
    @survey_templates = SurveyTemplate.all.order(:milestone_id)
  end

  def new
    @survey_template = SurveyTemplate.new
    render locals: {
             milestones: Milestone.all
           }
  end

  def create

  end

  def edit
    @survey_template = SurveyTemplate.find(params[:id])
  end

  def update
    @survey_template = SurveyTemplate.find(params[:id])

  end

  def destroy
    @survey_template = SurveyTemplate.find(params[:id])
    if @survey_template.destroy
      redirect_to survey_templates_path, flash: {success: t('.success_message')}
    else
      redirect_to survey_templates_path,
                  flash: {failure: t('.failure_message',
                                     error_msg: @survey_template.errors.full_messages.join(', '))}
    end
  end
end
