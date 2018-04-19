# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('config/application', __dir__)

Rails.application.load_tasks

if %w(development test).include? Rails.env
  require 'rubocop/rake_task'
  RuboCop::RakeTask.new

  desc 'Run code tests'
  task(:test_code) do
    system('script/test')
  end

  desc 'Run all tests'
  task(:test) do
    Rake::Task['test_code'].invoke
  end

  task(:default).clear
  task default: [:test]
end
