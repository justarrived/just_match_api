# frozen_string_literal: true
FrilansFinansApi.logger = Rails.logger
FrilansFinansApi.event_logger = FrilansFinansEventLogger.new
FrilansFinansApi.client_klass = FrilansFinansApi::Client
FrilansFinansApi.base_uri = AppSecrets.frilans_finans_base_uri
FrilansFinansApi.client_id = AppSecrets.frilans_finans_client_id
FrilansFinansApi.client_secret = AppSecrets.frilans_finans_client_secret
