# frozen_string_literal: true
require 'spec_support/runners/spec_runner_helper'

module FactoryLintRunner
  extend SpecRunnerHelper

  def self.run
    return unless execute_runner?('LINT_FACTORY')

    factories_to_lint = FactoryGirl.factories.reject do |factory|
      name = factory.name.to_s
      # Don't lint factories used for documentation generation or
      # the rating factories, since they have advanced validation rules
      name.ends_with?('for_docs') || name.start_with?('rating')
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
