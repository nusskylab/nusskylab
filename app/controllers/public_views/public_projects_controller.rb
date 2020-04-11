# Public View: project
class PublicViews::PublicProjectsController < ApplicationController
  def index
    !authenticate_user(false, false) && return
    @page_title = t('.page_title')
    @teams_table = {}
    all_cohorts.each do |cohort|
      teams = Team.where(
        cohort: cohort, has_dropped: false
      ).order(:project_level).reverse_order
      @teams_table[cohort] = teams
    end
  end
end
