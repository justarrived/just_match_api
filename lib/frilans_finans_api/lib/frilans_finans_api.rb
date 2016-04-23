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

  def self.client_klass
    @client_klass ||= DEFAULT_CLIENT_KLASS
  end

  def self.client_klass=(klass)
    @client_klass = klass
  end

  def self.reset_config
    @client_klass = DEFAULT_CLIENT_KLASS
  end
end
