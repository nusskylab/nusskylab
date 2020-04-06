# TeamsController
class MentorMatchingsController < ApplicationController
  def index
    !authenticate_user(true, true) && return
    cohort = params[:cohort] || current_cohort
    @mentor_matchings = MentorMatching.where(cohort: cohort)
    @page_title = t('.page_title')
    respond_to do |format|
      format.html do
        render locals: {
          all_cohorts: all_cohorts,
          cohort: cohort
        }
      end
      format.csv { send_data MentorMatching.to_csv(cohort: cohort) }
    end
  end
end

