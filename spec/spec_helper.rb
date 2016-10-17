# frozen_string_literal: true
if ENV.fetch('CODECLIMATE_REPO_TOKEN', false)
  require 'codeclimate-test-reporter'
  CodeClimate::TestReporter.start
elsif ENV.fetch('COVERAGE', false)
  require 'simplecov'
  SimpleCov.start 'rails'
end

require 'webmock/rspec'
require 'frilans_finans_api/test_helper'

Dir[Rails.root.join('spec/spec_support/spec_helpers/**/*.rb')].each { |f| require f }

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.include FrilansFinansApi::TestHelper

  config.expect_with :rspec do |expectations|
    # Better expetations output
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # Verify that test doubles only mocks existing methods
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  # Run tests in random order
  config.order = :random

  # Print the 10 slowest examples and example groups
  config.profile_examples = 10 if ENV['PROFILE_TESTS'] == 'true'

  # Limits the available syntax to the non-monkey patched syntax
  config.disable_monkey_patching!

  # These two settings work together to allow you to limit a spec run
  # to individual examples or groups you care about by tagging them with
  # `:focus` metadata. When nothing is tagged with `:focus`, all examples
  # get run.
  config.filter_run focus: ENV['CI_BUILD'] != 'true'
  config.run_all_when_everything_filtered = true

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options.
  config.example_status_persistence_file_path = 'spec/.rspec_examples.txt'
end

# Set test defaults
FrilansFinansApi.client_klass = FrilansFinansApi::FixtureClient
FrilansFinansApi.base_uri = 'https://example.com'
FrilansFinansApi.client_id = '123456'
FrilansFinansApi.client_secret = 'notsosecret'
FrilansFinansApi.event_logger = FrilansFinansApi::NilEventLogger.new

# Only allow the tests to connect to localhost and  allow codeclimate
# codeclimate (for test coverage reporting)
WebMock.disable_net_connect!(allow_localhost: true, allow: 'codeclimate.com')
