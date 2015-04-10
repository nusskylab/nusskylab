class AdvisersController < ApplicationController
  def index
    @advisers = Adviser.all
  end

  def new
    @adviser = Adviser.new
  end
end
