# frozen_string_literal: true

FrilansFinansAPI.configure do |config|
  config.logger = Rails.logger
  config.event_logger = FrilansFinansEventLogger.new
  config.client_klass = FrilansFinansAPI::Client
  config.base_uri = AppConfig.frilans_finans_base_uri
  config.client_id = AppSecrets.frilans_finans_client_id
  config.client_secret = AppSecrets.frilans_finans_client_secret
end
