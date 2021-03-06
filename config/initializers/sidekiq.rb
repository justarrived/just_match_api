# frozen_string_literal: true

require 'airbrake/sidekiq'
# Respect current locale when sending background emails
require 'sidekiq/middleware/i18n'

Sidekiq.default_worker_options = { 'backtrace' => true }

if Rails.env.production?
  redis_url = AppConfig.redis_url
  redis_timeout = AppConfig.redis_timeout

  Sidekiq.configure_server do |config|
    config.redis = { url: redis_url, network_timeout: redis_timeout }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: redis_url, network_timeout: redis_timeout, size: 2 }
  end
end
