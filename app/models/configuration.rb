class Configuration < ActiveRecord::Base
  def self.registration_open?
    get_truth_value('registration_status')
  end

  def self.set_registration_status(value)
    set_truth_value('registration_status', value)
  end

  def self.project_level_swap_open?
    get_truth_value('project_level_swap_status')
  end

  def self.set_project_level_swap_status(value)
    set_truth_value('project_level_swap_status', value)
  end

  def self.set_truth_value(field_name, value)
    config = Configuration.where(name: field_name).first_or_initialize
    config.value = value == true ? 'true' : 'false'
    config.save
  end

  def self.get_truth_value(field_name)
    config = Configuration.find_by(name: field_name)
    if config.nil?
      Configuration.create(name: field_name, value: 'false')
      false
    else
      config.value == 'true'
    end
  end

  private_class_method :set_truth_value, :get_truth_value
end
