module SubmissionsHelper

  def project_level_text (project_level)
    if project_level == 'vostok'
      text = 'Vostok'
    elsif project_level == 'project_gemini'
      text = 'Project Gemini'
    elsif project_level == 'apollo_11'
      text = 'Apollo 11'
    end
    text
  end

  def project_level_header (project_level, no_teams)
    "#{project_level} - #{no_teams} teams"
  end

  def image_tag_string (project_level)
    if project_level == 'vostok'
      tag_string = "Vostok_Icon.jpg"
    elsif project_level == 'project_gemini'
      tag_string = "Project_Gemini_Icon.png"
    elsif project_level == 'apollo_11'
      tag_string = "Apollo_11_Icon.png"
    end
    tag_string
  end

  def get_project_class_attribute (project_level)
    if (project_level == "Vostock")
      "fade in active"
    else
      "fade"
    end
  end

  def team_button_text (team)
    "#{team.id + 1} .  #{team.team_name}"
  end

end
