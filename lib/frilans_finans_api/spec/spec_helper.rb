# frozen_string_literal: true
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'frilans_finans_api'
require 'frilans_finans_api/test_helper'
require 'webmock/rspec'

WebMock.disable_net_connect!

# Set test defaults
FrilansFinansApi.configure do |config|
  config.client_klass = FrilansFinansApi::FixtureClient
  config.base_uri = 'https://example.com'
  config.client_id = '123456'
  config.client_secret = 'notsosecret'
end

RSpec.configure do |config|
  config.include FrilansFinansApi::TestHelper
end
