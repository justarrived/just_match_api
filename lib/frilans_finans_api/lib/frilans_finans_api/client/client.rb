# frozen_string_literal: true

require 'httparty'

module FrilansFinansApi
  class Client
    include HTTParty
    base_uri 'https://frilansfinans.se/api'

    HEADERS = {
      headers: {
        'User-Agent' => 'FrilansFinansAPI - Ruby client'
      }
    }.freeze

    attr_reader :headers, :credentials

    GRANT_TYPE = ENV['FRILANS_FINANS_GRANT_TYPE']
    CLIENT_ID = ENV['FRILANS_FINANS_CLIENT_ID']
    CLIENT_SECRET = ENV['FRILANS_FINANS_CLIENT_SECRET']

    def initialize(headers: {}, grant_type: GRANT_TYPE, client_id: CLIENT_ID, client_secret: CLIENT_SECRET) # rubocop:disable Metrics/LineLength
      @headers = HEADERS.merge(headers)
      @credentials = {
        grant_type: grant_type,
        client_id: client_id,
        client_secret: client_secret
      }
    end

    def get(uri:, query: {})
      opts = build_get_opts(query: query)
      self.class.get(uri, opts)
    end

    def post(uri:, query: {}, body: {})
      opts = build_post_opts(query: query, body: body)
      self.class.post(uri, opts)
    end

    def currencies(page: 1)
      get(uri: '/currencies', query: { page: page })
    end

    def professions(page: 1)
      get(uri: '/professions', query: { page: page })
    end

    def invoice(id:)
      get(uri: "/invoices/#{id}")
    end

    def create_user(attributes: {})
      data = { data: { attributes: attributes } }
      post(uri: '/users', body: data)
    end

    def create_company(attributes: {})
      data = { data: { attributes: attributes } }
      post(uri: '/companies', body: data)
    end

    def create_invoice(attributes: {})
      data = attributes
      post(uri: '/invoices', body: data)
    end

    private

    def build_get_opts(query: {})
      { query: query.merge(credentials) }.merge(headers)
    end

    def build_post_opts(query: {}, body: {})
      {
        query: query,
        body: body.merge(credentials)
      }.merge(headers)
    end
  end
end
