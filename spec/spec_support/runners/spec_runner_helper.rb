# frozen_string_literal: true
module SpecRunnerHelper
  def execute_runner?(env_name)
    # Only return true if running the entire test suite or if env_name is
    # explicitly set
    filtered_test = ARGV.map { |arg| arg.starts_with?('spec') }.include?(true)
    !filtered_test || ENV.fetch(env_name, false) == 'true'
  end
end
