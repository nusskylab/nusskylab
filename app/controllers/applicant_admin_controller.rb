class ApplicantAdminController < ApplicationController
    def index
      !authenticate_user(true, true) && return
      cohort = current_cohort
      # deadlines = ApplicationDeadlines.order(:id)
      peer_eval_open = ApplicationDeadlines.find_by(name: 'peer evaluation open date')
      peer_eval_open = peer_eval_open.submission_deadline
      team = Team.first
      #to-do: if no team
      render locals: {
          cohort: cohort,
          peer_eval_open: peer_eval_open,
          team: team
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
  end
  