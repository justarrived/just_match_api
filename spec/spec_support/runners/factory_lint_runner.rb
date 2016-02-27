# frozen_string_literal: true
require 'spec_support/runners/spec_runner_helper'

module FactoryLintRunner
  extend SpecRunnerHelper

  def self.run
    return unless execute_runner?('LINT_FACTORY')

    factories_to_lint = FactoryGirl.factories.reject do |factory|
      # Don't lint factories used for documentation generation
      factory.name.to_s.ends_with?('for_docs')
    end
    print 'Validating factories..'
    DatabaseCleaner.start
    FactoryGirl.lint(factories_to_lint)
    print "done \n"
  rescue => e
    DatabaseCleaner.clean
    raise e
  end
end
