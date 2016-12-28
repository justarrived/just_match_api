# frozen_string_literal: true
module Rack
  class Attack
    redis = AppConfig.redis_url
    Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new(redis)

    safelist('allow from localhost') do |req|
      '127.0.0.1' == req.ip || '::1' == req.ip
    end

    # Allow 50 requests per 10 seconds
    throttle('req/ip', limit: 50, period: 10.seconds, &:ip)

    self.throttled_response = lambda { |env|
      retry_after = (env['rack.attack.match_data'] || {})[:period]

      errors = JsonApiErrors.new
      errors.add(status: 429, detail: I18n.t('errors.rate_limit.details'))
      [
        429,
        {
          'Content-Type' => 'application/vnd.api+json',
          'Retry-After' => retry_after.to_s
        },
        [errors.to_json]
      ]
    }
  end
end
