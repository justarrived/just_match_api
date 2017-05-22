# frozen_string_literal: true

require 'welcome_app/version'

require 'welcome_app/client'

module WelcomeApp
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    block_given? ? yield(config) : config
    config
  end

  ConfigurationError = Class.new(RuntimeError)

  class Configuration
    attr_writer :base_uri, :client_key

    def initialize
      @base_uri = nil
      @client_key = nil
    end

    def base_uri
      @base_uri || fail(ConfigurationError, 'base_uri must be set')
    end

    def client_key
      @client_key || fail(ConfigurationError, 'client_key must be set')
    end
  end
end

WelcomeApp.configure
