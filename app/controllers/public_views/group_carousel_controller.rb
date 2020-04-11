# Public View: group_carousel
class PublicViews::GroupCarouselController < ApplicationController
  def index
    !authenticate_user(false, false) && return
    @page_title = t('.page_title')
    team_ids = params[:id]
    teams = Team.all
    images = []
    names = []

    # find the list of teams and their team names and add into the arrays
    team_ids.each do |id|
      teams.each do |team|
        if team.id.to_s == id
          images << team.poster_link
          names << team.team_name
        end
      end
    end

    @poster_links = images
    @team_names = names
  end
end
