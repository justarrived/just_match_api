# frozen_string_literal: true
Apipie.configure do |config|
  config.app_name                = 'JustMatch API'
  config.copyright               = '&copy; Just Arrived 2015'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/api_docs'
  config.reload_controllers      = Rails.env.development?
  config.namespaced_resources    = false
  config.validate                = false # Validate params against the doc spec
  config.markup                  = Apipie::Markup::Markdown.new
  config.api_routes              = Rails.application.routes
  config.api_controllers_matcher = Rails.root.join('app', 'controllers', 'api', '**', '*.rb').to_s # rubocop:disable Metrics/LineLength
  config.app_info['1.0'] = <<-EOS
    Welcome to the JustMatch API v1. The API is everything you need for building a
    well functioning client.
  EOS
end
