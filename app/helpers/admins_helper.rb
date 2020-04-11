module AdminsHelper
  def is_registration_open?
    Config.is_registration_open?
  end

  def is_project_level_locked?
    Config.is_project_level_locked?
  end
end
