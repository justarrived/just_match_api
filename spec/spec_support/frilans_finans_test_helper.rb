# frozen_string_literal: true
module FrilansFinansApiTest
  def isolate_frilans_finans_client(klass)
    before_klass = FrilansFinansApi.client_klass
    FrilansFinansApi.client_klass = klass
    result = yield(before_klass)
    FrilansFinansApi.client_klass = before_klass
    result
  end

  def stub_frilans_finans_auth_request
    # Stub auth request
    base_uri = ENV.fetch('FRILANS_FINANS_BASE_URI')
    headers = { 'User-Agent' => 'FrilansFinansAPI - Ruby client' }
    body = [
      'grant_type=client_credentials',
      "client_id=#{FrilansFinansApi.client_id}",
      "client_secret=#{FrilansFinansApi.client_secret}"
    ].join('&')

    response_body =  JSON.dump(
      'access_token' => 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
      'token_type' => 'Bearer',
      'expires_in' => 1200
    )

    stub_request(:post, "#{base_uri}/auth/accesstoken").
      with(body: body, headers: headers).
      to_return(status: 200, body: response_body, headers: {})
  end

  def frilans_finans_authed_request_headers
    {
      'Authorization' => 'Bearer xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
      'Content-Type' => 'application/json',
      'User-Agent' => 'FrilansFinansAPI - Ruby client'
    }
  end
end
