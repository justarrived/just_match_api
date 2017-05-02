# frozen_string_literal: true

FrilansFinansApi.configure do |config|
  config.logger = Rails.logger
  config.event_logger = FrilansFinansEventLogger.new
  config.client_klass = FrilansFinansApi::Client
  config.base_uri = AppConfig.frilans_finans_base_uri
  config.client_id = AppSecrets.frilans_finans_client_id
  config.client_secret = AppSecrets.frilans_finans_client_secret
end
