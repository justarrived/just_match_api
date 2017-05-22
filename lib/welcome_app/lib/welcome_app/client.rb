# frozen_string_literal: true

require 'httparty'

module WelcomeApp
  USER_AGENT = {
    'User-Agent' => 'WelcomeApp - Ruby client'
  }.freeze

  HEADERS = {
    'Content-Type' => 'application/json',
    'Accept' => 'application/json'
  }.merge!(USER_AGENT).freeze

  class Client
    def initialize(key: nil, base_uri: nil)
      @auth_key = key || WelcomeApp.config.client_key
      @base_uri = base_uri || WelcomeApp.config.base_uri
    end

    def user_exist?(email:)
      result = get('/user-exist', query: { email: email })
      result.body == 'true'
    end

    def get(path, query: {})
      HTTParty.get(base_uri + path, query: query, headers: headers)
    end

    private

    attr_reader :auth_key, :base_uri

    def headers
      HEADERS.merge(auth_headers).dup
    end

    def auth_headers
      { 'Authorization' => auth_key }
    end
  end
end
