# Public View: project
class PublicViews::PublicProjectsController < ApplicationController
  def index
    !authenticate_user(false, false) && return
    @page_title = t('.page_title')
    @teams_table = {}
    @cohorts = all_cohorts
    [all_cohorts.first].each do |cohort|
      teams = Team.where(
        cohort: cohort, has_dropped: false
      ).order(:project_level).reverse_order
      @teams_table[cohort] = teams
    end
  end

  def show
    !authenticate_user(false, false) && return
    @cohort = params[:id]
    @teams = Team.where(
      cohort: @cohort, has_dropped: false
    ).order(:project_level).reverse_order

    render 'show.js.erb', locals: {
      cohort: @cohort,
      teams: @teams
    }
  end
end
