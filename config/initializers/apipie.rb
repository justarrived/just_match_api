Apipie.configure do |config|
  config.app_name                = 'JustArrived'
  config.api_base_url            = '/api'
  config.doc_base_url            = '/api_docs'
  config.reload_controllers      = Rails.env.development?
  config.namespaced_resources    = false
  config.validate                = false # Validate params against the doc spec
  config.markup                  = Apipie::Markup::Markdown.new
  config.api_routes              = Rails.application.routes
  config.app_info['1.0'] = '
    Welcome to the JustArrived API v1. The API is everything you need for building a
    well functioning and nice client.
  '
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
