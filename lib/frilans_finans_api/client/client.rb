# frozen_string_literal: true

module FrilansFinansApi
  class Client
    include HTTParty
    base_uri 'https://frilansfinans.se/api'

    HEADERS = {
      headers: {
        'User-Agent' => 'FrilansFinansAPI - Ruby client'
      }
    }.freeze

    attr_reader :options

    def initialize
      @options = {}.merge(HEADERS)
    end

    def get(uri:, page: 1)
      opts = { query: { page: page } }.merge(options)
      self.class.get(uri, opts)
    end

    def professions(page: 1)
      get(uri: '/profession', page: page)
    end
  end
end
