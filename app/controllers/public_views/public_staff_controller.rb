# Public View: staff
class PublicViews::PublicStaffController < ApplicationController
  def index
    !authenticate_user(false, false) && return
    @page_title = t('.page_title')
    cohort = params[:cohort] || current_cohort
    facilitators = Facilitator.where(cohort: cohort)
    advisers = Adviser.where(cohort: cohort)
    tutors = Tutor.where(cohort: cohort)
    mentors = Mentor.where(cohort: cohort)
    staff_table = {}
    staff_table[:facilitators] = facilitators
    staff_table[:advisers] = advisers
    staff_table[:mentors] = mentors
    staff_table[:tutor] = tutors
    render locals: {
      staff: staff_table,
      cohort: cohort,
      all_cohorts: all_cohorts
    }
  end
end
