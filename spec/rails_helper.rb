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

require 'spec_support/geocoder_support'

# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migration.maintain_test_schema!

def run_test_suite_with_factory_linting?
  # Only run the factory linter if running the entire test suite or if
  # explicitly set
  !ARGV.first || ENV.fetch('LINT_FACTORY', false)
end

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
    begin
      # Since we're using Spring we must reload all factories
      # see: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#rails-preloaders-and-rspec
      FactoryGirl.reload
      # Validate that all factories are valid, will slow down the test startup
      # with a second or two, but can be very handy..
      if run_test_suite_with_factory_linting?
        begin
          factories_to_lint = FactoryGirl.factories.reject do |factory|
            # Don't lint factories used for documentation generation
            factory.name.to_s.ends_with?('for_docs')
          end
          print 'Validating factories..'
          DatabaseCleaner.start
          FactoryGirl.lint(factories_to_lint)
          print " done \n"
        rescue => e
          DatabaseCleaner.clean
          raise e
        end
      end
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
