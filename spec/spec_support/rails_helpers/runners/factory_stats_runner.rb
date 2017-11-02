# frozen_string_literal: true

require 'spec_support/rails_helpers/runners/spec_runner_helper'

module FactoryStatsRunner
  def self.start(factory_bot_stats)
    return unless SpecRunnerHelper.execute?('FACTORY_STATS')

    puts 'Subscribing to FactoryBot stats.'
    ActiveSupport::Notifications.subscribe('factory_bot.run_factory') do |_name, start, finish, _id, payload| # rubocop:disable Metrics/LineLength
      factory_name = payload[:name]
      strategy_name = payload[:strategy]

      factory_bot_stats.add(start, finish, factory_name, strategy_name)
    end
  end

  def self.finish(factory_bot_stats)
    return unless SpecRunnerHelper.execute?('FACTORY_STATS')

    puts 'Calculating FactoryBot stats.'
    factory_bot_stats.calculate_statistics

    results_path = 'tmp/factory_bot_stats.json'
    puts "Writing to FactoryBot stats to #{results_path}."
    File.write(results_path, factory_bot_stats.to_h.to_json)
  end
end
