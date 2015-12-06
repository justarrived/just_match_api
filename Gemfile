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

gem 'kaminari'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'faker'#, group: [:development, :test] This gem shouldn't need to be in production, but its handy during development

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'regressor'
end

group :development do
  gem 'letter_opener'
  gem 'bullet'
  gem 'binding_of_caller'
  gem 'better_errors'
  gem 'annotate'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'simplecov', require: false
end
