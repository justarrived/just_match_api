# frozen_string_literal: true
require 'spec_support/rails_helpers/runners/spec_runner_helper'

module DocExamplesRunner
  extend SpecRunnerHelper

  def self.run
    return unless execute_runner?('DOC_EXAMPLES')

    print 'Generating doc examples..'
    Doxxer.generate_response_examples
    print "done \n"
  end
end
