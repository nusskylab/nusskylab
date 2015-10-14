class ProjectListsController < ApplicationController
  def index
    not authenticate_user(false, false) and return
    @page_title = t('.page_title')
    @teams = Team.order(:project_level).reverse_order.all
  end
end
