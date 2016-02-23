# Public View: staff
class PublicViews::PublicStaffController < ApplicationController
  def index
    !authenticate_user(false, false) && return
    @page_title = t('.page_title')
    @staff_table = {}
    all_cohorts.each do |cohort|
      facilitators = Facilitator.where(cohort: cohort)
      advisers = Adviser.where(cohort: cohort)
      tutors = Tutor.where(cohort: cohort)
      @staff_table[cohort] = {}
      @staff_table[cohort][:facilitators] = facilitators
      @staff_table[cohort][:advisers] = advisers
      @staff_table[cohort][:tutor] = tutors
    end
  end
end
