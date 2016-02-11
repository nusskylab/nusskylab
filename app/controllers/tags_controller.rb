# TagsController
class TagsController < ApplicationController
  def index
    @tags = HashTag.all
    respond_to do |format|
      format.html { render }
      format.json { render json: @tags, status: :ok }
    end
  end
end
