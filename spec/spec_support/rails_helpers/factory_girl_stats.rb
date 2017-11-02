# frozen_string_literal: true

class FactoryBotStats
  attr_reader :results

  def initialize(log_slow: true, log_show_threshold: 0.3)
    @results = {}
    @log_slow = log_slow
    @log_show_threshold = log_show_threshold
  end

  def add(start, finish, factory_name, strategy_name)
    execution_time_in_seconds = finish - start

    results[factory_name] ||= {}
    results[factory_name][strategy_name] ||= {}
    results[factory_name][strategy_name][:count] ||= 0
    results[factory_name][strategy_name][:count] += 1
    results[factory_name][strategy_name][:execution_times_in_seconds] ||= []
    results[factory_name][strategy_name][:execution_times_in_seconds] << execution_time_in_seconds # rubocop:disable Metrics/LineLength

    if @log_slow && execution_time_in_seconds >= @log_show_threshold
      $stderr.puts "Slow factory: #{factory_name} using strategy #{strategy_name} [#{execution_time_in_seconds}s]" # rubocop:disable Metrics/LineLength
    end
    results[factory_name][strategy_name]
  end

  def calculate_statistics
    results.each do |factory_name, strategies|
      strategies.keys.each do |strategy_name|
        times = results[factory_name][strategy_name][:execution_times_in_seconds]
        total = times.sum
        average = total.fdiv(times.size)

        results[factory_name][strategy_name][:average_seconds] = average
        results[factory_name][strategy_name][:total_seconds] = total
      end
    end
    results
  end

  def to_h
    results
  end
end
