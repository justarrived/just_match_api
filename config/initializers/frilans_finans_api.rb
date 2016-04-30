# frozen_string_literal: true
FrilansFinansApi.client_klass = FrilansFinansApi::NilClient
FrilansFinansApi.base_uri = ENV.fetch('FRILANS_FINANS_BASE_URI')
FrilansFinansApi.client_id = ENV.fetch('FRILANS_FINANS_CLIENT_ID')
FrilansFinansApi.client_secret = ENV.fetch('FRILANS_FINANS_CLIENT_SECRET')
