# ReceivedFeedbacksController: manage actions related received_feedbacks
#   index: list all received feedbacks
class ReceivedMentorCommentsController < ApplicationController
  def index
    !can_view_received_feedbacks_page && return
    @mentor_comments= MentorComment.where(target_team_id: params[:team_id])
    @page_title = t('.page_title')
  end

  private

  def can_view_received_feedbacks_page
    if params[:team_id]
      @team = Team.find(params[:team_id]) ||
              (record_not_found && return)
      !authenticate_user(true, false, @team.get_relevant_users(false, false)) &&
        (return false)
    else
      raise ActionController::RoutingError.new(t('application.path_not_found_message'))
    end
    true
  end
end
