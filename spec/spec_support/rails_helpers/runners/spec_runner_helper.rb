# frozen_string_literal: true

module SpecRunnerHelper
  def execute_runner?(env_name, default: true)
    filtered_test = ARGV.any? do |arg|
      arg.starts_with?('spec') || arg.starts_with?('./spec')
    end

    env_value = ENV[env_name]
    if env_value == 'false'
      false
    elsif env_value == 'true'
      true
    else
      default && !filtered_test
    end
  end
end
