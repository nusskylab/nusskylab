module AdminsHelper
  def registration_status
    ENV['REGISTRATION_STATUS']
  end

  def is_registration_open?
    ENV['REGISTRATION_STATUS'] == 'open'
  end

  def project_level_swap_status
    ENV['PROJECT_LEVEL_SWAP_STATUS']
  end

  def is_project_level_locked?
    ENV['PROJECT_LEVEL_SWAP_STATUS'] == 'locked'
  end
end
