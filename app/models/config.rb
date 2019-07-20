class Config < ActiveRecord::Base
  validates :name, uniqueness: true, presence: true
  validates :value, presence: true

  STATUS = {
    registration: 'registration_status',
    project_level_swap: 'project_level_swap_status'
  }

  # Config with an array of values.
  # If only 2 values are specified, the config is known as "toggeable".
  VALUES = {
    registration_status: ['close', 'open'],
    project_level_swap_status: ['locked', 'unlocked']
  }

  def self.is_registration_open?
    get_value(STATUS[:registration]) == 'open'
  end

  def self.toggle_registration()
    toggle_value(STATUS[:registration])
  end

  def self.is_project_level_locked?
    get_value(STATUS[:project_level_swap]) == 'locked'
  end

  def self.toggle_project_level_swap()
    toggle_value(STATUS[:project_level_swap])
  end


  #### Private class methods ####

  def self.get_value(field_name)
    config = Config.find_by(name: field_name)
    if config.nil?
      config = Config.create(name: field_name, value: VALUES[field_name.to_sym][0])
    end
    config.value
  end

  # Pre-requisite: A config that is toggleable.
  # Assumption: If this method is used on a config with no existing value,
  #             we will assume the intention is to toggle the default_value.
  def self.toggle_value(field_name)
    if !is_toggleable_field?(field_name)
      raise 'Incorrect usage of method (toggle_value): make sure you define the ' +
        'field_name in VALUES hash with their respective 2 values'
    end

    config = Config.where(name: field_name).first_or_initialize
    values = VALUES[field_name.to_sym]
    if config.value.nil?
      updated_value = values[1]
    else
      updated_value = values[0] == config.value ? values[1] : values[0]
    end
    config.value = updated_value
    config.save
  end

  def self.is_toggleable_field?(field_name)
    !VALUES[field_name.to_sym].nil? &&
      VALUES[field_name.to_sym].length == 2
  end

  private_class_method :get_value, :is_toggleable_field?, :toggle_value
end
