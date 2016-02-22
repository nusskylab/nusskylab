# Public View: project
class PublicViews::PublicProjectsController < ApplicationController
  def index
    !authenticate_user(false, false) && return
    @page_title = t('.page_title')
    teams = Team.order(:project_level).reverse_order.all.select do |team|
      !team.has_dropped
    end
    @teams_table = { 2015 => teams, 2014 => [], 2013 => [] }
  end
end
