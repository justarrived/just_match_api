# frozen_string_literal: true

module FrilansFinansApi
  class Request
    include HTTParty
    base_uri 'https://frilansfinans.se/api'

    HEADERS = {
      headers: {
        'User-Agent' => 'FrilansFinansAPI - Ruby client'
      }
    }.freeze

    attr_reader :options

    def initialize(page: 1)
      @options = { query: { page: page } }.merge(HEADERS)
    end

    def professions
      self.class.get('/profession', options)
    end
  end
end
