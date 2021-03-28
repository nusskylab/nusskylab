class ApplicantAdminController < ApplicationController
    def index
      !authenticate_user(true, true) && return
      cohort = current_cohort
      # deadlines = ApplicationDeadlines.order(:id)
      peer_eval_open = ApplicationDeadlines.find_by(name: 'peer evaluation open date').submission_deadline
      website_open = ApplicationDeadlines.find_by(name: 'portal open date').submission_deadline
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
      user = User.first
      render locals: {
        user: user
      }
    end

  end
  