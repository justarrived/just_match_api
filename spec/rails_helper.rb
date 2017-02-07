# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

if Rails.env.production?
  abort('The Rails environment is running in production mode!')
end
require 'spec_helper'
require 'rspec/rails'
require 'paperclip/matchers'

require 'pundit/rspec'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

Dir[
  Rails.root.join('spec', 'spec_support', 'rails_helpers', '**', '*.rb')
].each { |f| require f }

SMSClient.client = FakeSMS

# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include Paperclip::Shoulda::Matchers

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

      FactoryLintRunner.run

      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end

  config.after(:suite) do
    FileUtils.rm_rf(Dir[Rails.root.join('spec', 'test_files').to_s])

    RubocopRunner.run
    CheckDBIndexesRunner.run
    CheckDBUniqIndexesRunner.run
  end

  config.before(:each) do
    FakeSMS.messages = []
  end
end
