# frozen_string_literal: true
require 'spec_support/runners/spec_runner_helper'

module RubocopRunner
  extend SpecRunnerHelper

  def self.run
    return unless execute_runner?('RUBOCOP')

    print 'Running rubocop..'
    require 'rubocop/rake_task'

    RuboCop::RakeTask.new
    Rake::Task['rubocop'].invoke
    print "done \n"
  end
end
