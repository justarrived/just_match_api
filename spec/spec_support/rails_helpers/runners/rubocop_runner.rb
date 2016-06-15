# frozen_string_literal: true
require 'spec_support/rails_helpers/runners/spec_runner_helper'

module RubocopRunner
  extend SpecRunnerHelper

  def self.run
    return unless execute_runner?('RUBOCOP')

    require 'rubocop/rake_task'

    RuboCop::RakeTask.new
    Rake::Task['rubocop'].invoke
  end
end
