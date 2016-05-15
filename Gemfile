# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.6'
gem 'pg', '~> 0.15' # Use postgresql as the database for Active Record

gem 'rails-api', '~> 0.4', require: false

gem 'sidekiq', '~> 4.1' # Background worker (Redis-backed)
gem 'sinatra', '~> 1.4', require: false # Required for sidekiqs web interface

gem 'active_model_serializers', '~> 0.10.0.rc5' # Serialize models to JSON

gem 'blazer', '~> 1.3' # Explore data with SQL

# Interact with Frilans Finans API
gem 'frilans_finans_api', path: 'lib/frilans_finans_api'

gem 'paperclip', '~> 5.0.0.beta2' # Image handler
gem 'aws-sdk', '~> 2.3' # Upload images to AWS S3

gem 'airbrake', '~> 5.3' # Error catcher and reporter

group :production do
  gem 'rails_12factor', '~> 0.0.3' # Heroku integration
end

gem 'apipie-rails', '~> 0.3' # Easy API documentation
gem 'maruku', '~> 0.7' # Needed for apipie-rails markdown support

gem 'kaminari', '~> 0.16' # Easy pagination

gem 'bcrypt', '~> 3.1.7', require: true # Encrypt passwords

gem 'puma', '~> 3.4' # App server

gem 'newrelic_rpm', '~> 3.15' # Performance monitoring
gem 'skylight', '~> 0.10'  # Performance monitoring

gem 'geocoder', '~> 1.3' # Geocode resources

gem 'administrate', '~> 0.2' # Admin dashboard
gem 'administrate-field-image', '~> 0.0.2' # Administrate image support
gem 'uglifier', '~> 3.0' # Needed administrate assets compilation

gem 'pundit', '~> 1.1' # Authorization policies

gem 'faker', '~> 1.6' # Easily generate fake data (used for seeding dev/test/staging)

gem 'rack-timeout', '~> 0.4' # Kill requests that run for too long
gem 'rack-cors', '~> 0.4', require: 'rack/cors' # Configure CORS
gem 'rack-attack', '~> 4.4' # Throttle API usage
gem 'redis-activesupport', '~> 4.1' # To use Redis as the cache store for rack-attack

gem 'yagni_json_encoder', '~> 0.0.2' # Make Rails use the OJ gem for JSON

gem 'rails-i18n', '~> 4.0.0' # Rails translations

gem 'honey_format', '~> 0.2' # Simple CSV reading

group :development, :test do
  gem 'byebug', '~> 8.2'
  gem 'rspec-rails', '~> 3.4'
  gem 'regressor', '~> 0.6'
  gem 'rubocop', '~> 0.35', require: false
  gem 'dotenv-rails', '~> 2.1'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'immigrant', '~> 0.3'
  gem 'consistency_fail', '~> 0.3'
  gem 'bullet', '~> 5.0'
  gem 'fog', '~> 1.38' # Cloud services gem, in production the aws-sdk gem is used
  gem 'rspec_junit_formatter', '~> 0.2'
end

group :development do
  gem 'letter_opener', '~> 1.4'
  gem 'binding_of_caller', '~> 0.7'
  gem 'better_errors', '~> 2.1'
  gem 'annotate', '~> 2.7'
  gem 'web-console', '~> 3.0'
  gem 'spring', '~> 1.6'
  gem 'spring-commands-rspec', '~> 1.0'
  gem 'i18n-tasks', '~> 0.9.2'
  gem 'i18n_generators', '~> 2.1'
end

group :test do
  gem 'codeclimate-test-reporter', '~> 0.5', require: false
  gem 'simplecov', '~> 0.11', require: false
  gem 'database_cleaner', '~> 1.5'
  gem 'webmock', '~> 2.0'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'timecop', '~> 0.8.0'
end
