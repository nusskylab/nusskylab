# Project level Configuration
# To add more project level configurations please follow the following steps:
#   1. Add your configuration name to STATUS hash.
#   2. Add the string values that your configuration has.
#   3. Define getter and setter methods for your configuration.
#
# Implementation:
#   The Config model is implemented with 2 columns in the database table.
#   1 representing the name, another representing the value of the configuration.
#   Hence, each row in the database will represent a single configuration.
#
# Usage:
#   The Config model must be used from it's declared methods.
#   Meaning, you should not do things like Config.create/Config.new... etc
#   outside of the Config model itself.
#   Hence, if you want to add more configuration, and the current model methods
#   doesn't satisfy your requirement, feel free to add more methods.
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
