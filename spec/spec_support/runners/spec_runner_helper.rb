# frozen_string_literal: true
module SpecRunnerHelper
  def execute_runner?(env_name)
    # Only return true if running the entire test suite or if env_name is
    # explicitly set
    !ARGV.first || ENV.fetch(env_name, false)
  end
end
