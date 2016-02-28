# frozen_string_literal: true
module SpecRunnerHelper
  def execute_runner?(env_name)
    filtered_test = ARGV.map { |arg| arg.starts_with?('spec') }.include?(true)

    env_value = ENV[env_name]
    if env_value == 'false'
      false
    elsif env_value == 'true'
      true
    else
      !filtered_test
    end
  end
end
