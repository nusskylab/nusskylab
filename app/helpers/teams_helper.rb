module TeamsHelper
  def can_edit_team
    loggedin_user = current_user
    if loggedin_user.nil?
      return false
    end
    @team.get_relevant_users.each do |user|
      if user.id == loggedin_user.id
        return true
      end
    end
    return false
  end
end
