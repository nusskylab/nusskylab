# Public View: staff
class PublicViews::PublicStaffController < ApplicationController
  def index
    !authenticate_user(false, false) && return
    @page_title = t('.page_title')
    cohort = params[:cohort] || current_cohort
    facilitators = Facilitator.where(
      cohort: cohort
    ).joins(:user).order('user_name')
    advisers = Adviser.where(
      cohort: cohort
    ).joins(:user).order('user_name')
    tutors = Tutor.where(
      cohort: cohort
    ).joins(:user).order('user_name')
    mentors = Mentor.where(
      cohort: cohort
    ).joins(:user).order('user_name')
    staff_table = {}
    staff_table[:facilitators] = facilitators
    staff_table[:advisers] = advisers
    staff_table[:mentors] = mentors
    staff_table[:tutors] = tutors
    render locals: {
      staff: staff_table,
      cohort: cohort,
      all_cohorts: all_cohorts
    }
  end
end
