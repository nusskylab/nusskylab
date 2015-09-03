module TeamsHelper
  def can_current_user_download_csv
    if is_current_user_admin?
      return true
    end
    is_current_user_contained?(Adviser.all.map{|adviser| adviser.user})
  end

  def can_current_user_create_new_team
    is_current_user_admin?
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
    if is_current_user_admin?
      return true
    end
    if is_view
      is_current_user_contained?(team.get_relevant_users(false, false))
    else
      is_current_user_contained?(team.get_relevant_users)
    end
    false
  end

  def can_current_user_delete_team(team = nil)
    team ||= @team
    if is_current_user_admin?
      return true
    end
    (not team.adviser_id.blank? and current_user and current_user.id == team.adviser.user_id)
  end
end
