require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vagrant
  class Application < Rails::Application
    config.time_zone = 'Singapore'

    I18n.available_locales = [:en]
    config.i18n.default_locale = :en

    config.active_record.raise_in_transactional_callbacks = true
  end
end