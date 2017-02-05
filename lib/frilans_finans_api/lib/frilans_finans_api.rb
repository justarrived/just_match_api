# frozen_string_literal: true

require 'frilans_finans_api/client/fixture_client'
require 'frilans_finans_api/client/nil_client'
require 'frilans_finans_api/client/walker'
require 'frilans_finans_api/client/client'
require 'frilans_finans_api/client/terms'

require 'frilans_finans_api/models/company'
require 'frilans_finans_api/models/currency'
require 'frilans_finans_api/models/employment_certificate'
require 'frilans_finans_api/models/invoice'
require 'frilans_finans_api/models/profession'
require 'frilans_finans_api/models/salary'
require 'frilans_finans_api/models/tax'
require 'frilans_finans_api/models/user'

require 'frilans_finans_api/document'
require 'frilans_finans_api/resource'

require 'frilans_finans_api/statuses'

require 'frilans_finans_api/nil_logger'
require 'frilans_finans_api/nil_event_logger'

module FrilansFinansApi
  DEFAULT_CLIENT_KLASS = Client
  DEFAULT_BASE_URI = 'https://frilansfinans.se/api'

  def self.client_klass
    @client_klass ||= DEFAULT_CLIENT_KLASS
  end

  def self.client_klass=(klass)
    @client_klass = klass
  end

  def self.client_id
    @client_id || fail("#{name}.client_id must be set")
  end

  def self.client_id=(client_id)
    @client_id = client_id
  end

  def self.client_secret
    @client_secret || fail("#{name}.client_secret must be set")
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

  def self.logger
    @logger ||= NilLogger.new
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.event_logger
    @event_logger ||= NilEventLogger.new
  end

  def self.event_logger=(logger)
    @event_logger = logger
  end

  def self.reset_config
    @client_klass = DEFAULT_CLIENT_KLASS
    @base_uri = DEFAULT_BASE_URI
  end
end
