# frozen_string_literal: true

Rack::Timeout.timeout = AppConfig.rack_timeout
