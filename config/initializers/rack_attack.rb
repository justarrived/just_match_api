# frozen_string_literal: true
module Rack
  class Attack
    redis = ENV.fetch('REDISTOGO_URL', 'localhost')
    Rack::Attack.cache.store = ActiveSupport::Cache::RedisStore.new(redis)

    whitelist('allow-localhost') do |req|
      '127.0.0.1' == req.ip || '::1' == req.ip
    end

    # Allow 5 requests per second
    throttle('req/ip', limit: 5, period: 1.second, &:ip)

    # Only allow 6 login attempts in a minute
    Rack::Attack.throttle('logins/email', limit: 6, period: 60.seconds) do |req|
      true if req.path == '/api/v1/user_sessions' && req.post?
    end

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
