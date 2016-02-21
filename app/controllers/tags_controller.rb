# TagsController
class TagsController < ApplicationController
  def index
    label = params[:label]
    labels = params[:labels].split(',') if params[:labels]
    if label
      @tags = HashTag.where(label: label)
    elsif labels
      @tags = HashTag.where(label: labels)
    else
      @tags = HashTag.all
    end
    respond_to do |format|
      format.html { render }
      format.json { render json: @tags, status: :ok }
    end
  end
end
