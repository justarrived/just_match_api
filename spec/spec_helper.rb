if ENV.fetch('COVERAGE', false)
  require 'simplecov'
  SimpleCov.start 'rails'
end

require 'webmock/rspec'

require 'support/geocoder'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
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
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options.
  config.example_status_persistence_file_path = 'spec/.rspec_examples.txt'

  # Before the test suite is run
  config.before(:suite) do
    begin
      # Since we're using Spring we must reload all factories
      # see: https://github.com/thoughtbot/factory_girl/blob/master/GETTING_STARTED.md#rails-preloaders-and-rspec
      FactoryGirl.reload
      # Validate that all factories are valid
      FactoryGirl.lint
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end
end

# Don't allow the test to make web requests unless its to localhost
WebMock.disable_net_connect!(allow_localhost: true)
