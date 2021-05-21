class ApplicantAdminController < ApplicationController
    def index
      !authenticate_user(true, true) && return
      cohort = current_cohort
      peer_eval_open = ApplicationDeadlines.find_by(name: 'peer evaluation open date').submission_deadline
      website_open = ApplicationDeadlines.find_by(name: 'portal open date').submission_deadline
      team = Team.first
      stage = 'all'
      #to-do: if no team
      render locals: {
          cohort: cohort,
          peer_eval_open: peer_eval_open,
          team: team,
          website_open: website_open,
          stage: stage
      }
    end

    def prepare_peer_eval
      !authenticate_user(true, true) && return
      puts '!!!!!!!'
      #to-do: if no team
      render locals: {
          teams: Team.all
      }
    end
    
    def getEvaluatedTeams(beginI, endI, teamID, teamIDs, size)
      if beginI + size - 1 > endI
          teamsBack = teamIDs[beginI..teamIDs.length() - 1]
          teamsFront = teamIDs[0..endI]
          teams = teamsFront + teamsBack
      else
          teams = teamIDs[beginI..endI]
      end
      if teams.delete(teamID)
        if beginI > 0
          teams << teamIDs[beginI - 1]
        else
          teams << teamIDs[-1]
        end
      end
      return teams
    end

    def applicant_eval_matching
      # authenticate users
      !authenticate_user(true, true) && return
      # if confirm false, return
      confirm_params = confirm_params.permit(:confirm)
      if confirm_params[:confirm] == 'false'
        redirect_to applicant_admin_index_path(), flash: {
          success: 'Action cancelled.'
        }
      else
        teams = Team.where("proposal_link != \'\'")
        teamIDs = []
        teams.each do |team|
          teamIDs << team.id
        end
        teamIDs = teamIDs.shuffle
        size = 4
        # to-do: 'Invalid size': < 2 * size + 1
        # fix self evaluate
        teamIDs.each_with_index do |teamID, i|
            team = Team.find_by(id: teamID)
            members = team.students
            # update params, shift the links to peer eval page
            member1 = members[0].id
            member2 = members[1].id
            member1Begin = i % teamIDs.length()
            member1End = (i + size - 1) % teamIDs.length()
            member2Begin = (i + size) % teamIDs.length()
            member2End = (i + size + size - 1) % teamIDs.length()
            teamsBy1 = getEvaluatedTeams(member1Begin, member1End, teamID, teamIDs, size)
            teamsBy2 = getEvaluatedTeams(member2Begin, member2End, teamID, teamIDs, size)
            members[0].evaluatee_ids = teamsBy1
            members[1].evaluatee_ids = teamsBy2
            members[0].save
            members[1].save
          end
        # update team attributes: for each member, evaluaters, evaluatees, application status   
        redirect_to applicant_admin_manage_peer_eval_path(), flash: {
          success: 'Success.'
        }
      end
    end

    def purge_and_open
      !authenticate_user(true, true) && return
      user = User.first
      render locals: {
        user: user
      }
    end

    def manage_peer_eval
      !authenticate_user(true, true) && return
      render locals: {
        teams: Team.all,
        team: Team.first
      }
    end
  end
  