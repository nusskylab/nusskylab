# NOTE: Addressing Issue #546 (2017), advisors will be able to map relations between ALL teams.

# EvaluatingsController: manage actions related to evaluatings
#   index:   list of evaluatings
#   new:     view to create an evaluating
#   create:  create an evaluating
#   edit:    edit and evaluating
#   destroy: delete an evaluating
class ApplicantEvaluatingsController < ApplicationController

      
    def prepare_eval
      !authenticate_user(true, true) && return
      cohort = current_cohort
      #to-do: if no team, and only the qualified team
      render locals: {
          teams: Team.find(cohort: cohort),
          # team: Team.first
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
      # confirm = params.permit(:confirm)
      # if confirm[:confirm] == 'false'
      #   redirect_to applicant_evaluatings_path(), flash: {
      #     warning: 'Cancelled.'
      #   }
      # end

      #todo: cohort
      teams = Team.where("application_status = 'c'")
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
        teamsBy1.each do |id|
          team = Team.find_by(id: id)
          team.evaluator_students << member1.name
          team.save
        end
        teamsBy2.each do |id|
          team = Team.find_by(id: id)
          team.evaluator_students << member2.name
          team.save
        end
      end
      # update team attributes: for each member, evaluaters, evaluatees, application status   
      redirect_to applicant_eval_team_path(), flash: {
        success: 'Success.'
      }
    end
    # def new
    #   !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    #   @evaluating = Evaluating.new
    #   cohort = params[:cohort] || current_cohort
    #   adviser = Adviser.find_by(user_id: current_user.id, cohort: cohort)
    #   if current_user_admin? or adviser
    #     teams = Team.where(cohort: cohort)
    #   # elsif adviser
    #   #   teams = adviser.teams.where(cohort: cohort)
    #   end
    #   @page_title = t('.page_title')
    #   render locals: { teams: teams, adviser: adviser}
    # end
  
    # def create
    #   !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    #   @evaluating = Evaluating.new(evaluating_params)
    #   if create_or_update_evaluation_relationship
    #     redirect_to evaluatings_path, flash: {
    #       success: t('.success_message',
    #                  entity1_name: @evaluating.evaluator.team_name,
    #                  entity2_name: @evaluating.evaluated.team_name)
    #     }
    #   else
    #     redirect_to new_evaluating_path, flash: {
    #       danger: t('.failure_message',
    #                 error_message: @evaluating.errors.full_messages.join(', '))
    #     }
    #   end
    # end
  
    # def edit
    #   @evaluating = Evaluating.find(params[:id])
    #   # !authenticate_user(true, false, evaluating_permitted_users) && return
    #   !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    #   cohort = params[:cohort] || current_cohort
    #   if current_user_admin? or current_user_adviser?
    #     teams = Team.where(cohort: cohort)
    #     # teams = Team.all
    #   # elsif (adviser = current_user_adviser?)
    #   #   teams = adviser.teams
    #   end
    #   @page_title = t('.page_title')
    #   render locals: { teams: teams }
    # end
  
    # def update
    #   @evaluating = Evaluating.find(params[:id])
    #   # !authenticate_user(true, false, evaluating_permitted_users) && return
    #   !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    #   @evaluating.assign_attributes(evaluating_params)
    #   if create_or_update_evaluation_relationship
    #     redirect_to evaluatings_path, flash: {
    #       success: t('.success_message',
    #                  entity1_name: @evaluating.evaluator.team_name,
    #                  entity2_name: @evaluating.evaluated.team_name)
    #     }
    #   else
    #     redirect_to edit_evaluating_path(@evaluating), flash: {
    #       danger: t('.failure_message',
    #                 error_message: @evaluating.errors.full_messages.join(', '))
    #     }
    #   end
    # end
  
    # def destroy
    #   @evaluating = Evaluating.find(params[:id])
    #   # !authenticate_user(true, false, evaluating_permitted_users) && return
    #   !authenticate_user(true, false, Adviser.all.map(&:user)) && return
    #   if @evaluating.destroy
    #     redirect_to evaluatings_path, flash: {
    #       success: t('.success_message',
    #                  entity1_name: @evaluating.evaluator.team_name,
    #                  entity2_name: @evaluating.evaluated.team_name)
    #     }
    #   else
    #     redirect_to evaluatings_path, flash: {
    #       danger: t('.failure_message',
    #                 error_message: @evaluating.errors.full_messages.join(', '))
    #     }
    #   end
    # end
  
    # private
  
    # def evaluating_params
    #   params.require(:evaluating).permit(:evaluated_id, :evaluator_id)
    # end
  
    # def evaluating_permitted_users
    #   evaluating_users = []
    #   adviser = @evaluating.evaluated.adviser
    #   if adviser and adviser.user_id == current_user.id
    #     evaluating_users.append(adviser.user)
    #   end
    #   evaluating_users
    # end
  
    # def create_or_update_evaluation_relationship
    #   if current_user_admin? or current_user_adviser?
    #     return @evaluating.save ? @evaluating : nil
    #   # else
    #   #   if (@evaluating.evaluated &&
    #   #       @evaluating.evaluated.adviser.user_id == current_user.id) &&
    #   #      (@evaluating.evaluator &&
    #   #       @evaluating.evaluator.adviser.user_id == current_user.id)
    #   #     return @evaluating.save ? @evaluating : nil
    #   #   else
    #   #     @evaluating.errors.add(:evaluated_id, 'User not allowed to do this')
    #   else
    #     @evaluating.errors.add(:evaluated_id, 'User not allowed to do this')
    #   end
    #   nil
    # end
  end
  