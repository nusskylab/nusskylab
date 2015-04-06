class MilestonesController < ApplicationController
  def index
    @milestones = Milestone.all
  end

  def new
    @milestone = Milestone.new
  end

  def create
    # TODO: find a more elegant way of creating date. besides, the front end presentation looks like crap
    test = Milestone.new(params.require(:milestone).permit(:name, :deadline))
    @milestone = Milestone.create_or_update_by_name(:name => test.name, :deadline => test.deadline)
    redirect_to milestones_path
  end

  def show
  end

  def update
  end

  def destroy
  end
end
