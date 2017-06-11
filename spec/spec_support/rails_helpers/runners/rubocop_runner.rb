# frozen_string_literal: true

require 'spec_support/rails_helpers/runners/spec_runner_helper'

module RubocopRunner
  def self.run
    return unless SpecRunnerHelper.execute?('RUBOCOP')

    require 'rubocop/rake_task'

    RuboCop::RakeTask.new
    Rake::Task['rubocop'].invoke
  end
end
