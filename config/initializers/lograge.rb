# frozen_string_literal: true

Rails.application.configure do
  config.lograge.base_controller_class = %w[ActionController::API ActionController::Base]
end
