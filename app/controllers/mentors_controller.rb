class MentorsController < ApplicationController
  def index
    @mentors = Mentor.all
  end

  def new
    @mentor = Mentor.new
  end

  def create
    redirect_to mentors_path
  end

  def edit
    @mentor = Mentor.find(params[:id])
  end

  def update
    redirect_to mentors_path
  end

  def destroy
    @mentor = Mentor.find(params[:id])
    @mentor.destroy
    redirect_to mentors_path
  end
end
