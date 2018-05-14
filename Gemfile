# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.0'

gem 'rails', '5.2.0' # Ruby on Rails MVC framework

gem 'bootsnap', '>= 1.3', require: false # Optimize Rails boot time

# TEXT PROCESSING
gem 'kramdown', '~> 1.16' # Markdown <> HTML
gem 'loofah', '~> 2.2' # HTML sanitizer
gem 'rinku', '~> 2.0.4' # Autolink

# SERVER
gem 'lograge', '~> 0.10' # Less verbose Rails log in production
gem 'puma', '~> 3.11' # App server

# Analytics
gem 'ahoy_matey', '~> 1.6'

# STORAGE
gem 'aws-sdk-s3', '~> 1.9' # Upload images to AWS S3
gem 'pg', '~> 1.0' # Use postgresql as the database for Active Record
gem 'redis-activesupport', '~> 5.0' # To use Redis as the cache store for rack-attack

# ACTIVERECORD
gem 'association_count', '~> 1.0' # Simple count for ActiveRecord associations

# RACK MIDDLEWARE
gem 'rack-attack', '~> 5.2' # Throttle API usage
gem 'rack-cors', '~> 1.0', require: 'rack/cors' # Configure CORS
gem 'rack-timeout', '~> 0.4' # Kill requests that run for too long

# BACKGROUND JOBS
gem 'sidekiq', '< 6' # Background worker (Redis-backed)

# MONITORING
gem 'airbrake', '~> 7.3' # Error catcher and reporter
gem 'newrelic_rpm', '~> 5.1' # Performance monitoring

# DATABASE / MODELS
gem 'ancestry', '~> 3.0' # Organize records in a tree structure
gem 'kaminari', '~> 1.1' # Easy pagination

# JSON
gem 'active_model_serializers', '~> 0.10' # Serialize models to JSON
gem 'jsonapi_helpers', '~> 0.2' # JSONAPI helpers

# IMAGES
gem 'paperclip', '~> 6.0' # Image handler

# HTTP
gem 'httparty', '~> 0.16' # Make HTTP requests with ease

# SECURITY
gem 'bcrypt', '~> 3.1.11', require: true # Encrypt passwords
gem 'pundit', '~> 1.1' # Authorization policies

# ADMIN
gem 'active_admin_filters_visibility', github: 'activeadmin-plugins/active_admin_filters_visibility'
gem 'active_admin_scoped_collection_actions', github: 'activeadmin-plugins/active_admin_scoped_collection_actions'
gem 'active_admin_theme', '~> 1.0' # activeadmin theme
gem 'activeadmin', '~> 1.3' # Admin interface
gem 'blazer', '~> 1.8' # Explore data with SQL
gem 'chosen-rails', '~> 1.8' # Needed for autocomplete select input for activeadmin
gem 'inherited_resources', '~> 1.8' # activeadmin Rails 5
gem 'uglifier', '~> 4.1' # Needed for activeadmin assets compilation

gem 'arbetsformedlingen', '~> 0.4' # Gem for publishing jobs to Arbetsformedlingen (Swedish Employment Service)

gem 'metrojobb', '~> 0.6', '>= 0.6.1' # Gem for building a feed for Metrojobb

gem 'welcome_app', path: 'lib/welcome_app' # Interact with WelcomeApp!

# Invoices
gem 'frilans_finans_api', '~> 0.4' # Interact with Frilans Finans API

# NOTIFICATIONS
gem 'email_reply_parser', '~> 0.5' # Parse reply emails
gem 'mail', '~> 2.6', '>= 2.6.6' # General email functionality
gem 'twilio-ruby', '~> 5.9' # Send SMS notifications

# GEO/LOCALE/LANGUAGE UTILS
gem 'banktools-se', '~> 2.6' # Validate Swedish bank account
gem 'countries', '~> 2.1', require: 'countries/global' # Country data in various locales
gem 'geocoder', '~> 1.4' # Geocode resources
gem 'global_phone', '~> 1.0' # Format cell phone numbers
gem 'google-cloud-translate', '~> 1.2' # Translate with Google Translate API
gem 'i18n_data', '~> 0.8' # Language and country names in various languages
gem 'iban-tools', '~> 1.1' # Validate IBAN
gem 'mailcheck', github: 'mailcheck/mailcheck-ruby' # Email suggestions for common email spelling misstakes
gem 'personnummer', '~> 0.1.0' # Swedish "personummer" or "samordningsnummer"
gem 'rails-i18n', '~> 5.1' # Rails translations

# PERFORMANCE GEMS
gem 'fast_blank', '~> 1.0' # Re-implements #blank? in C
gem 'fast_xs', '~> 0.8' # Re-implements String#to_xs in C
gem 'yagni_json_encoder', '~> 1.0' # Make Rails use the OJ gem for JSON

# DOCS
gem 'apipie-rails', '~> 0.5' # Easy API documentation
gem 'maruku', '~> 0.7' # Needed for apipie-rails markdown support

# UTILS
gem 'faker', '~> 1.8' # Easily generate fake data (used for seeding dev/test/staging)
gem 'honey_format', '~> 0.6' # Simple CSV reading

# DEVELOPMENT/TEST/DOCS
group :development, :test, :docs do
  gem 'bullet', '~> 5.7'
  gem 'byebug', '~> 10.0'
  gem 'consistency_fail', '~> 0.3'
  gem 'dotenv-rails', '~> 2.4'
  gem 'factory_bot_rails', '~> 4.8'
  gem 'fog', '~> 2.0' # Cloud services gem, in production the aws-sdk gem is used
  gem 'immigrant', '~> 0.3'
  gem 'rspec-rails', '~> 3.7'
  gem 'rspec_junit_formatter', '~> 0.2'
  gem 'rubocop', '~> 0.55', require: false
end

group :development do
  gem 'annotate', '~> 2.7'
  gem 'better_errors', '~> 2.4'
  gem 'binding_of_caller', '~> 0.8'
  gem 'derailed_benchmarks', '~> 1.3'
  gem 'i18n-tasks', '~> 0.9.21'
  gem 'i18n_generators', '~> 2.1'
  gem 'letter_opener', '~> 1.6'
  gem 'listen', '~> 3.1'
  gem 'memory_profiler', '~> 0.9'
  gem 'spring', '~> 2.0'
  gem 'spring-commands-rspec', '~> 1.0'
  gem 'stackprof', '~> 0.2'
  gem 'web-console', '~> 3.6'
end

group :test, :docs do
  gem 'codeclimate-test-reporter', '~> 1.0', require: false
  gem 'database_cleaner', '~> 1.7'
  gem 'fuubar', '~> 2.3'
  gem 'rails-controller-testing', '~> 1.0'
  gem 'rb-readline', '~> 0.5'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'simplecov', '~> 0.16', require: false
  gem 'timecop', '~> 0.8'
  gem 'webmock', '~> 3.4'
end
