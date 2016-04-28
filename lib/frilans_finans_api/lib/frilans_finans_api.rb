# frozen_string_literal: true

require 'frilans_finans_api/client/fixture_client'
require 'frilans_finans_api/client/nil_client'
require 'frilans_finans_api/client/walker'
require 'frilans_finans_api/client/client'
require 'frilans_finans_api/client/company'
require 'frilans_finans_api/client/currency'
require 'frilans_finans_api/client/invoice'
require 'frilans_finans_api/client/profession'
require 'frilans_finans_api/client/tax'
require 'frilans_finans_api/client/user'

require 'frilans_finans_api/document'
require 'frilans_finans_api/resource'

module FrilansFinansApi
  DEFAULT_CLIENT_KLASS = FixtureClient
  DEFAULT_BASE_URI = 'https://frilansfinans.se/api'

  def self.client_klass
    @client_klass ||= DEFAULT_CLIENT_KLASS
  end

  def self.client_klass=(klass)
    @client_klass = klass
  end

  def self.client_id
    @client_id || fail('client_id must be set')
  end

  def self.client_id=(client_id)
    @client_id = client_id
  end

  def self.client_secret
    @client_secret || fail('client_secret must be set')
  end

  def self.client_secret=(client_secret)
    @client_secret = client_secret
  end

  def self.base_uri
    @base_uri ||= DEFAULT_BASE_URI
  end

  def self.base_uri=(uri)
    @base_uri = uri
  end

  def self.reset_config
    @client_klass = DEFAULT_CLIENT_KLASS
    @base_uri = DEFAULT_BASE_URI
  end
end
