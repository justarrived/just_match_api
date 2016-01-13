source 'https://rubygems.org'

ruby '2.3.0'

gem 'rails', '4.2.5'
gem 'pg', '~> 0.15' # Use postgresql as the database for Active Record

gem 'rails-api', '~> 0.4'
gem 'active_model_serializers', '~> 0.10.0.rc3' # Serialize models to JSON

gem 'geocoder', '~> 1.2' # Geocode resources
group :production do
  gem 'rails_12factor', '~> 0.0.3' # Heroku integration
end

gem 'apipie-rails', '~> 0.3' # Easy API documentation
gem 'maruku', '~> 0.7' # Needed for apipie-rails markdown support

gem 'kaminari', '~> 0.16' # Easy pagination

gem 'bcrypt', '~> 3.1.7', require: true

# Use Puma as the app server
gem 'puma', '~> 2.15'
gem 'rack-timeout', '~> 0.3'

group :development, :test do
  gem 'byebug', '~> 8.2'
  gem 'rspec-rails', '~> 3.4'
  gem 'regressor', '~> 0.6'
  gem 'faker', '~> 1.6'
  gem 'foreman', '~> 0.7'
  gem 'rubocop', '~> 0.35', require: false
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
  gem 'rails-i18n', '~> 4.0.0' # For 4.0.x
  gem 'i18n-tasks', '~> 0.9.2'
end

group :test do
  gem 'codeclimate-test-reporter', '~> 0.4', require: false
  gem 'simplecov', '~> 0.11', require: false
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner', '~> 1.5'
  gem 'webmock', '~> 1.21'
  gem 'rspec-activemodel-mocks', '~> 1.0'
end
