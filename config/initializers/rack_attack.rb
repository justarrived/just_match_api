# frozen_string_literal: true
module Rack
  class Attack
    redis = ENV.fetch('REDIS_URL', 'localhost')
    Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new(redis)

    whitelist('allow-localhost') do |req|
      '127.0.0.1' == req.ip || '::1' == req.ip
    end

    # Allow 50 requests per 10 seconds
    throttle('req/ip', limit: 50, period: 10.second, &:ip)

    self.throttled_response = lambda { |env|
      retry_after = (env['rack.attack.match_data'] || {})[:period]
      [
        429,
        { 'Content-Type' => 'application/json', 'Retry-After' => retry_after.to_s },
        [{ error: 'Throttle limit reached. Retry later.' }.to_json]
      ]
    }
  end
end
