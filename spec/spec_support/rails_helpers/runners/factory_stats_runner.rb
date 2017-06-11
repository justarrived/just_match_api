# frozen_string_literal: true

require 'spec_support/rails_helpers/runners/spec_runner_helper'

module FactoryStatsRunner
  extend SpecRunnerHelper

  def self.start(factory_girl_stats)
    return unless execute_runner?('FACTORY_STATS')

    ActiveSupport::Notifications.subscribe('factory_girl.run_factory') do |_name, start, finish, _id, payload| # rubocop:disable Metrics/LineLength
      factory_name = payload[:name]
      strategy_name = payload[:strategy]

      factory_girl_stats.add(start, finish, factory_name, strategy_name)
    end
  end

  def self.finish(factory_girl_stats)
    return unless execute_runner?('FACTORY_STATS')

    factory_girl_stats.calculate_statistics
    File.write('tmp/factory_girl_stats.json', factory_girl_stats.to_h.to_json)
  end
end
