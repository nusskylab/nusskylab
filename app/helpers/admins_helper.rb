module AdminsHelper
  def registration_status
    ENV['REGISTRATION_STATUS']
  end

  def is_registration_open?
    ENV['REGISTRATION_STATUS'] == 'open'
  end
end
