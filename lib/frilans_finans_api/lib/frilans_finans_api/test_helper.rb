# frozen_string_literal: true

module FrilansFinansApi
  module TestHelper
    module_function

    def isolate_frilans_finans_client(klass)
      before_klass = FrilansFinansApi.config.client_klass
      FrilansFinansApi.config.client_klass = klass
      result = yield(before_klass)
      FrilansFinansApi.config.client_klass = before_klass
      result
    end

    def stub_frilans_finans_auth_request
      # Stub auth request
      base_uri = FrilansFinansApi.config.base_uri
      headers = { 'User-Agent' => 'FrilansFinansAPI - Ruby client' }
      body = [
        'grant_type=client_credentials',
        "client_id=#{FrilansFinansApi.config.client_id}",
        "client_secret=#{FrilansFinansApi.config.client_secret}"
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

    def mock_httparty_response(code: 200, body: '{}', uri: 'http://example.com')
      request_struct = Struct.new(:uri)
      request = request_struct.new(URI(uri))

      response_struct = Struct.new(:code, :body, :request)
      response_struct.new(code, body, request)
    end
  end
end
