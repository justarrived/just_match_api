source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '4.2.5'
gem 'pg', '~> 0.15' # Use postgresql as the database for Active Record

gem 'rails-api', '~> 0.4'
gem 'active_model_serializers', '~> 0.10.0.rc3'

gem 'geocoder', '~> 1.2'
gem 'rails_12factor', '~> 0.0.3'

gem 'apipie-rails', '~> 0.3' # Easy API documentation
gem 'maruku', '~> 0.7' # Needed for apipie-rails markdown support

gem 'kaminari', '~> 0.16'

# Use Unicorn as the app server
gem 'unicorn'
gem 'rack-timeout'

group :development, :test do
  gem 'byebug', '~> 8.2'
  gem 'rspec-rails', '~> 3.4'
  gem 'regressor', '~> 0.6'
  gem 'faker', '~> 1.6'
end

group :development do
  gem 'letter_opener', '~> 1.4'
  gem 'bullet', '~> 4.14'
  gem 'binding_of_caller', '~> 0.7'
  gem 'better_errors', '~> 2.1'
  gem 'annotate', '~> 2.6'
  gem 'web-console', '~> 2.0'
  gem 'spring', '~> 1.5'
  gem 'spring-commands-rspec', '~> 1.0'
end

group :test do
  gem 'codeclimate-test-reporter', require: false
  gem 'simplecov', '~> 0.11', require: false
  gem 'factory_girl_rails', '~> 4.0'
  gem 'database_cleaner', '~> 1.5'
  gem 'webmock', '~> 1.21'
end
