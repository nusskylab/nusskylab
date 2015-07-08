class MilestonesController < ApplicationController
  layout 'admins'

  def index
    not check_access(true, true) and return
    @milestones = Milestone.all
  end

  def new
    not check_access(true, true) and return
    @milestone = Milestone.new
  end

  def create
    not check_access(true, true) and return
    @milestone = Milestone.new(get_milestone_params)
    if @milestone.save
      flash = {}
      flash[:success] = 'The milestone is successfully created'
      redirect_to milestones_path, flash: flash
    else
      render 'new'
    end
  end

  def show
    not check_access(true, true) and return
    @milestone = Milestone.find(params[:id])
  end

  def edit
    not check_access(true, true) and return
    @milestone = Milestone.find(params[:id])
  end

  def update
    not check_access(true, true) and return
    @milestone = Milestone.find(params[:id])
    if @milestone.update(get_milestone_params)
      redirect_to milestones_path, flash: {success: 'The milestone is successfully edited'}
    else
      redirect_to edit_milestone_path(@milestone.id), flash: {danger: @milestone.errors.full_messages.join(', ')}
    end
  end

  def destroy
    not check_access(true, true) and return
    @milestone = Milestone.find(params[:id])
    @milestone.destroy
    flash = {}
    flash[:success] = 'The milestone is successfully deleted'
    redirect_to milestones_path, flash: flash
  end

  def get_home_link
    admin? ? admin_path(admin?) : '/'
  end

  def get_page_title
    @page_title = @page_title || 'Milestones | Orbital'
    super
  end

  private
    def get_milestone_params
      params.require(:milestone).permit(:name, :submission_deadline, :peer_evaluation_deadline)
    end
end
