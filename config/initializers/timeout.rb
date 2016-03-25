# frozen_string_literal: true
Rack::Timeout.timeout = ENV.fetch('RACK_TIMEOUT', 15).to_i # seconds
