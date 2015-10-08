class MilestonesController < ApplicationController
  def index
    not authenticate_user(true, true) and return
    @page_title = t('.page_title')
    @milestones = Milestone.all
  end

  def new
    not authenticate_user(true, true) and return
    @page_title = t('.page_title')
    @milestone = Milestone.new
  end

  def create
    not authenticate_user(true, true) and return
    @milestone = Milestone.new(get_milestone_params)
    if @milestone.save
      redirect_to milestones_path, flash: {success: t('.success_message', milestone_name: @milestone.name)}
    else
      redirect_to new_milestone_path, flash: {success: t('.failure_message', error_messages: @milestone.errors.full_messages.join(', '))}
    end
  end

  def show
    not authenticate_user(true, true) and return
    @milestone = Milestone.find(params[:id])
    @page_title = t('.page_title', milestone_name: @milestone.name)
  end

  def edit
    not authenticate_user(true, true) and return
    @milestone = Milestone.find(params[:id])
    @page_title = t('.page_title', milestone_name: @milestone.name)
  end

  def update
    not authenticate_user(true, true) and return
    @milestone = Milestone.find(params[:id])
    if @milestone.update(get_milestone_params)
      redirect_to milestones_path, flash: {success: t('.success_message', milestone_name: @milestone.name)}
    else
      redirect_to edit_milestone_path(@milestone), flash: {success: t('.failure_message', error_messages: @milestone.errors.full_messages.join(', '))}
    end
  end

  def destroy
    not authenticate_user(true, true) and return
    @milestone = Milestone.find(params[:id])
    if @milestone.destroy
      redirect_to milestones_path, flash: {success: t('.success_message', milestone_name: @milestone.name)}
    else
      redirect_to milestone_path, flash: {success: t('.failure_message', error_messages: @milestone.errors.full_messages.join(', '))}
    end
  end

  private
  def get_milestone_params
    params.require(:milestone).permit(:name, :submission_deadline, :peer_evaluation_deadline)
  end
end
