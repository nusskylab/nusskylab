class MilestonesController < ApplicationController
  layout 'admins'

  def index
    @milestones = Milestone.all
  end

  def new
    @milestone = Milestone.new
  end

  def create
    test = Milestone.new(get_milestone_params)
    @milestone = Milestone.new(:name => test.name, :deadline => test.deadline)
    if @milestone.save
      flash = {}
      flash[:success] = 'The milestone is successfully created'
      redirect_to milestones_path, flash: flash
    else
      render 'new'
    end
  end

  def show
    @milestone = Milestone.find(params[:id])
  end

  def edit
    @milestone = Milestone.find(params[:id])
  end

  def update
    @milestone = Milestone.find(params[:id])
    if @milestone.update(get_milestone_params)
      flash = {}
      flash[:success] = 'The milestone is successfully edited'
      redirect_to milestones_path, flash: flash
    else
      render 'edit'
    end
  end

  def destroy
    @milestone = Milestone.find(params[:id])
    @milestone.destroy
    flash = {}
    flash[:success] = 'The milestone is successfully deleted'
    redirect_to milestones_path, flash: flash
  end

  private
    def get_milestone_params
      params.require(:milestone).permit(:name, :deadline)
    end
end
