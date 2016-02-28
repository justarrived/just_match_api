# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end
require 'spec_helper'
require 'rspec/rails'
require 'shoulda/matchers'
require 'pundit/rspec'
require 'webmock/rspec'

Dir[Rails.root.join('spec/spec_support/**/*.rb')].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Run each example within a transaction
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  # Before the test suite is run
  config.before(:suite) do
    DocExamplesRunner.run
    RubocopRunner.run
    CheckDBIndexesRunner.run

    begin
      # Since we're using Spring we must reload all factories
      # see: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#rails-preloaders-and-rspec
      FactoryGirl.reload

      FactoryLintRunner.run

      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end
end

# Only allow the tests to connect to localhost and  allow codeclimate
# codeclimate (for test coverage reporting)
WebMock.disable_net_connect!(allow_localhost: true, allow: 'codeclimate.com')
