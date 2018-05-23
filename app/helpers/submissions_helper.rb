module SubmissionsHelper

  def get_project_class_attribute (project_level)
    if (project_level == "Vostock")
      "fade in active"
    else
      "fade"
    end
  end

  def get_team_button_text (team)
    "#{team.id + 1} .  #{team.team_name}"
  end

end
