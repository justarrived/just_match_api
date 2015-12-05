Apipie.configure do |config|
  config.app_name                = 'JustArrived'
  config.api_base_url            = ''
  config.doc_base_url            = '/api_docs'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
