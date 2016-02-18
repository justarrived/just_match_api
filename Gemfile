# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', github: 'rails/rails'
gem 'pg', '~> 0.15' # Use postgresql as the database for Active Record

# Serialize models to JSON
gem 'active_model_serializers', github: 'rails-api/active_model_serializers'

group :production do
  gem 'rails_12factor', '~> 0.0.3' # Heroku integration
end

gem 'apipie-rails', '~> 0.3' # Easy API documentation
gem 'maruku', '~> 0.7' # Needed for apipie-rails markdown support

gem 'kaminari', '~> 0.16' # Easy pagination

gem 'bcrypt', '~> 3.1.7', require: true

gem 'puma', '~> 2.16' # Use Puma as the app server
gem 'rack-timeout', '~> 0.3' # Kill requests that run for too long

# gem 'newrelic_rpm', '~> 3.14' # Performance monitoring

gem 'geocoder', '~> 1.2' # Geocode resources

gem 'pundit', '~> 1.1' # Authorization policies

gem 'faker', '~> 1.6' # Easily generate fake data (used for seeding dev/test/staging)

group :development, :test do
  gem 'byebug', '~> 8.2'
  # gem 'rspec-rails', '~> 3.4'
  gem 'rspec-rails', git: 'https://github.com/rspec/rspec-rails.git', branch: 'master'
  gem 'rspec-core', git: 'https://github.com/rspec/rspec-core.git', branch: 'master'
  gem 'rspec-support', git: 'https://github.com/rspec/rspec-support.git', branch: 'master'
  gem 'rspec-expectations', git: 'https://github.com/rspec/rspec-expectations.git', branch: 'master'
  gem 'rspec-mocks', git: 'https://github.com/rspec/rspec-mocks.git', branch: 'master'
  # gem 'regressor', '~> 0.6'
  gem 'rubocop', '~> 0.35', require: false
  gem 'dotenv-rails', '~> 2.1'
end

group :development do
  gem 'letter_opener', '~> 1.4'
  gem 'bullet', '~> 5.0'
  gem 'binding_of_caller', '~> 0.7'
  gem 'better_errors', '~> 2.1'
  gem 'annotate', '~> 2.7'
  gem 'web-console', '~> 3.0'
  gem 'spring', '~> 1.6'
  gem 'spring-commands-rspec', '~> 1.0'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'rails-i18n', '~> 5.0.0.beta1'
  gem 'i18n-tasks', '~> 0.9.2'
end

group :test do
  gem 'codeclimate-test-reporter', '~> 0.4', require: false
  gem 'simplecov', '~> 0.11', require: false
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner', '~> 1.5'
  gem 'webmock', '~> 1.21'
  gem 'rspec-activemodel-mocks', '~> 1.0'
  gem 'rails-controller-testing', '~> 0.0.3'
end
