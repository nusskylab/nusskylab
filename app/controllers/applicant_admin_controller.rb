class ApplicantAdminController < ApplicationController
    def index
      !authenticate_user(true, true) && return
      cohort = current_cohort
      # deadlines = ApplicationDeadlines.order(:id)
      peer_eval_open = ApplicationDeadlines.find_by(name: 'peer evaluation open date')
      peer_eval_open = peer_eval_open.submission_deadline
      website_open = ApplicationDeadlines.find_by(name: 'portal open date')
      team = Team.first
      #to-do: if no team
      render locals: {
          cohort: cohort,
          peer_eval_open: peer_eval_open,
          team: team,
          website_open: website_open
      }
    end

    def prepare_peer_eval
      !authenticate_user(true, true) && return
      team = Team.first
      #to-do: if no team
      render locals: {
          team: team
      }
    end

    def purge_and_open
      !authenticate_user(true, true) && return
      # confirm
    end

    def confirm_purge_and_open
      !authenticate_user(true, true) && return
      #purge: delete students, delete application_status attributes, delete evaluators attributes
      User.where(application_status: 'fail').destroy_all
      all_students = Students.all
      all_students.each do |student|
        student.evaluatee_ids.clear
        student.evaluator_ids.clear
      end
      #update the students' access
      
    end
  end
  