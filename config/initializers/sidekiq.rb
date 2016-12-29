# frozen_string_literal: true
require 'airbrake/sidekiq/error_handler'
# Respect current locale when sending background emails
require 'sidekiq/middleware/i18n'

if Rails.env.production?
  redis_url = AppConfig.redis_url
  redis_timeout = AppConfig.redis_timeout

  Sidekiq.configure_server do |config|
    config.redis = { url: redis_url, network_timeout: redis_timeout, size: 20 }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: redis_url, network_timeout: redis_timeout, size: 2 }
  end
end
