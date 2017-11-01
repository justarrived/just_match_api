# frozen_string_literal: true

require 'spec_support/rails_helpers/runners/spec_runner_helper'

module FactoryLintRunner
  def self.run
    return unless SpecRunnerHelper.execute?('LINT_FACTORY')

    factories_to_lint = FactoryBot.factories.reject do |factory|
      name = factory.name.to_s
      # Don't lint factories used for documentation generation or
      # the rating factories, since they have advanced validation rules
      name.ends_with?('for_docs') || name.start_with?('rating')
    end
    print 'Validating factories..'
    DatabaseCleaner.start
    FactoryBot.lint(factories_to_lint)
    DatabaseCleaner.clean
    print "done \n"
  rescue => e
    DatabaseCleaner.clean
    raise e
  end
end
