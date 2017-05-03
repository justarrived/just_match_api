# frozen_string_literal: true

require 'frilans_finans_api/version'

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
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    block_given? ? yield(config) : config
  end

  class Configuration
    attr_accessor :client_klass, :base_uri,
                  :logger, :event_logger, :base_uri

    attr_writer :client_id, :client_secret

    def initialize
      @client_klass = Client
      @client_id = nil
      @client_secret = nil
      @base_uri = 'https://frilansfinans.se/api'
      @logger = NilLogger.new
      @event_logger = NilEventLogger.new
    end

    def client_id
      @client_id || fail('#client_id must be set')
    end

    def client_secret
      @client_secret || fail('#client_secret must be set')
    end
  end
end
