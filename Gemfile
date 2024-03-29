source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.0'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.6'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
gem 'kredis'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem 'image_processing', '~> 1.12'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  gem 'figaro'

  gem 'launchy'
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  gem 'spring'

  # https://github.com/BetterErrors/better_errors
  gem 'better_errors'
  gem 'binding_of_caller'

  gem 'rubocop'
  gem 'rubocop-faker'
  gem 'rubocop-rails'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'

  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop-rspec'
end

# UI
gem 'view_component'

# authentication
gem 'devise', github: 'ghiculescu/devise', branch: 'error-code-422'
gem 'devise-encryptable'
gem 'devise-security'

#  validations
gem 'email_validator'
gem 'phonelib'

# error handling
gem 'gaffe'

# job processing
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'sidekiq-status'
gem 'sidekiq-unique-jobs'

# money
gem 'activemerchant'
gem 'currency_select'
gem 'monetize'
gem 'money-heuristics'
gem 'money-rails'

# Country select
gem 'country_select'

# cockroachdb with rails 7 support
#
# main gem: https://github.com/cockroachdb/activerecord-cockroachdb-adapter
# with support: https://github.com/keithdoggett/activerecord-cockroachdb-adapter/tree/ar-70
# gem 'activerecord-cockroachdb-adapter', github: 'keithdoggett/activerecord-cockroachdb-adapter', branch: 'ar-70'
gem 'activerecord-cockroachdb-adapter', '~> 7.0.0'

gem 'pagy'

gem 'data_migrate'
