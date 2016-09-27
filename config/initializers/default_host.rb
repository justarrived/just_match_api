# frozen_string_literal: true

host = ENV.fetch('APP_HOST', 'https://api.justarrived.se')
Rails.application.routes.default_url_options = { host: host }
