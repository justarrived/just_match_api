# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'frilans_finans_api'
require 'webmock/rspec'
require 'spec_support/frilans_finans_api_test'

WebMock.disable_net_connect!

# Set test defaults
FrilansFinansApi.client_klass = FrilansFinansApi::FixtureClient
FrilansFinansApi.base_uri = 'https://example.com'
FrilansFinansApi.client_id = '123456'
FrilansFinansApi.client_secret = 'notsosecret'

RSpec.configure do |config|
  config.include FrilansFinansApiTest
end
