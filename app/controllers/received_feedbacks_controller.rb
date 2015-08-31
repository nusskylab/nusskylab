class ReceivedFeedbacksController < ApplicationController
  layout 'general_layout'

  def index
    not can_view_received_feedbacks_page and return
    if params[:team_id]
      @feedbacks = Feedback.where(target_team_id: params[:team_id])
    elsif params[:adviser_id]
      @feedbacks = Feedback.where(adviser_id: params[:adviser_id])
    end
    @page_title = t('.page_title')
  end

  private
  def can_view_received_feedbacks_page
    if params[:team_id]
      @team = Team.find(params[:team_id]) or record_not_found
      not authenticate_user(true, false, @team.get_relevant_users(false, false)) and return false
    elsif params[:adviser_id]
      @adviser = Adviser.find(params[:adviser_id]) or record_not_found
      not authenticate_user(true, false, [@adviser.user]) and return false
    else
      raise ActionController::RoutingError.new(t('application.path_not_found_message'))
    end
    return true
  end
end
