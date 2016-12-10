source 'https://rubygems.org' do
  # Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
  gem 'rails', '4.2.2'
  # Use postgres as the database for Active Record
  gem 'pg', '~> 0.18.3'
  # Use SCSS for stylesheets
  gem 'sass-rails', '~> 5.0'
  # Use Uglifier as compressor for JavaScript assets
  gem 'uglifier', '>= 1.3.0'
  # Use CoffeeScript for .coffee assets and views
  gem 'coffee-rails', '~> 4.1.0'
  # Use Puma as the app server
  gem 'puma', '~> 2.11.2'

  # Use devise for email sign-up and sign-in
  gem 'devise', '~> 3.5.2'
  # Use omniauth for openid authentication
  gem 'omniauth', '~> 1.2.2'
  gem 'omniauth-openid', '~> 1.0.1'

  # Turbolinks makes following links in your web application faster.
  # Read more: https://github.com/rails/turbolinks
  gem 'turbolinks', '~> 2.5.3'
  # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
  gem 'jbuilder', '~> 2.0'
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', group: :doc

  # Use bootstrap for styling
  gem 'bootstrap-sass', '~> 3.3.4'
  # Use jquery as the JavaScript library
  gem 'jquery-rails', '~> 4.0.5'
  # simple_form for form validation
  gem 'simple_form', '~> 3.1.1'
  # tiny_mce for rails
  gem 'tinymce-rails', '~> 4.2.5'
  # internalization
  gem 'rails-i18n', '~> 4.0.5'
  # datetime picker
  gem 'momentjs-rails', '>= 2.9.0'
  gem 'bootstrap3-datetimepicker-rails', '~> 4.15.35'
  # Gravatar
  gem 'gravtastic', '~> 3.2.6'

  # Use Capistrano for deployment
  # gem 'capistrano-rails', group: :development

  group :development, :test do

    # Spring speeds up development by keeping your application
    # running in the background.
    # Read more: https://github.com/rails/spring
    gem 'spring'

    # rspec for test & dev
    gem 'rspec-rails', '3.3.3'
    gem 'database_cleaner', '~> 1.5.0'
    gem 'factory_girl_rails', '~> 4.5.0'
    gem 'capybara', '~> 2.5.0'
    gem 'selenium-webdriver', '~> 2.48.0'
    gem 'capybara-webkit', '~> 1.7.1'
  end

  group :development do
    # Access an IRB console on exception pages or by using
    # <%= console %> in views
    gem 'web-console', '~> 2.0'
  end

  group :test do
    # simplecov
    gem 'simplecov', '~> 0.10.0'
    # codeclimate coverage
    gem 'codeclimate-test-reporter'
  end
end

source 'https://rails-assets.org' do
  gem 'rails-assets-jquery.tablesorter', '~> 2.23.2'
  gem 'rails-assets-select2', '~> 4.0.0'
  gem 'rails-assets-autosize', '~> 3.0.13'
end

ruby "2.3.1"