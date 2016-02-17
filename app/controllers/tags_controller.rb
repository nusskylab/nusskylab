# TagsController
class TagsController < ApplicationController
  def index
    label = params[:label]
    if label
      @tags = HashTag.where(label: label)
    else
      @tags = HashTag.all
    end
    respond_to do |format|
      format.html { render }
      format.json { render json: @tags, status: :ok }
    end
  end
end
