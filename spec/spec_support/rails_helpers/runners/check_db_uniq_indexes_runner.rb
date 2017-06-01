# frozen_string_literal: true

require 'spec_support/rails_helpers/runners/spec_runner_helper'

module CheckDBUniqIndexesRunner
  extend SpecRunnerHelper

  def self.run
    return unless execute_runner?('CHECK_DB_UNIQ_INDEXES', default: false)

    puts 'Will watch for missing DB uniqueness indexes during test suite..'

    require 'consistency_fail/enforcer'
    ConsistencyFail::Enforcer.enforce!
  end
end
