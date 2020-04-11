# MilestonesController: manage actions related to milestone
#   index:   list of milestones
#   new:     view to create a new milestone
#   create:  create a new milestone
#   show:    view of a milestone
#   edit:    view to update a milestone
#   update:  update a milestone
#   destroy: destroy a milestone
class MilestonesController < ApplicationController
  def index
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    @milestones = Milestone.where(cohort: current_cohort)
  end

  def new
    !authenticate_user(true, true) && return
    @page_title = t('.page_title')
    @milestone = Milestone.new
  end

  def create
    !authenticate_user(true, true) && return
    @milestone = Milestone.new(milestone_params)
    is_success = @milestone.save
    redirect_after_actions(is_success, milestones_path, new_milestone_path)
  end

  def show
    !authenticate_user(true, true) && return
    @milestone = Milestone.find(params[:id])
    @page_title = t('.page_title', milestone_name: @milestone.name)
  end

  def edit
    !authenticate_user(true, true) && return
    @milestone = Milestone.find(params[:id])
    @page_title = t('.page_title', milestone_name: @milestone.name)
  end

  def update
    !authenticate_user(true, true) && return
    @milestone = Milestone.find(params[:id])
    is_success = @milestone.update(milestone_params)
    redirect_after_actions(is_success, milestones_path,
                           edit_milestone_path(@milestone))
  end

  def destroy
    !authenticate_user(true, true) && return
    @milestone = Milestone.find(params[:id])
    is_success = @milestone.destroy
    redirect_after_actions(is_success, milestones_path, milestones_path)
  end

  private

  def milestone_params
    params.require(:milestone).permit(:name,
                                      :submission_deadline,
                                      :peer_evaluation_deadline)
  end

  def redirect_after_actions(is_success, success_path, failure_path)
    if is_success
      redirect_to success_path, flash: {
        success: t('.success_message', milestone_name: @milestone.name)
      }
    else
      redirect_to failure_path, flash: {
        danger: t('.failure_message',
                  error_message: @milestone.errors.full_messages.join(', '))
      }
    end
  end
end
