module TeamsHelper
  def can_current_user_download_csv
    if current_user_admin?
      return true
    end
    not Adviser.all.map{|adviser| adviser.user}.index {|user| user.id == current_user.id}.nil?
  end

  def can_current_user_create_new_team
    current_user_admin?
  end

  def can_current_user_view_team(team = nil)
    can_view_or_edit_team(team, true)
  end

  def can_current_user_edit_team(team = nil)
    can_view_or_edit_team(team, false)
  end

  def can_view_or_edit_team(team = nil, is_view = true)
    team ||= @team
    if current_user.nil?
      return false
    end
    if current_user_admin?
      return true
    end
    not team.get_relevant_users((not is_view), (not is_view)).index{|user| user.id == current_user.id}.nil?
  end

  def can_current_user_delete_team(team = nil)
    team ||= @team
    if current_user_admin?
      return true
    end
    (not team.adviser_id.blank? and current_user and current_user.id == team.adviser.user_id)
  end

    
  def delete_evaluator 
    !authenticate_user(true, true) && return
    @team = Team.find(params[:id]) || (record_not_found && return)
    @team.evaluator_students.delete(params[:evaluator_email])
    if @team.save!
      redirect_to edit_evaluators_team_path(@team), flash: {
        success: "Success."
      }
    else
      redirect_to edit_evaluators_team_path(@team), flash: {
        danger: "Action Failed."
      }
    end
  end
end
