# Public View: mentor_slides
class PublicViews::MentorSlidesController < ApplicationController
  def index
    !authenticate_user(false, false) && return
    @page_title = t('.page_title')
    profile_links = []
    mentor_names = []
    mentors = Mentor.where(
      cohort: current_cohort
    ).joins(:user).order('user_name')
    mentors.each do |mentor|
      if (mentor.slide_link != "")
        profile_links << mentor.slide_link
        mentor_names << mentor.user.user_name
      end
    end
    @slide_links = profile_links
    @names = mentor_names
  end
end
