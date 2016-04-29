# frozen_string_literal: true
require 'frilans_finans_api/client/request'

module FrilansFinansApi
  class Client
    attr_reader :request

    def initialize(base_uri: nil, client_id: nil, client_secret: nil)
      @request = Request.new(
        base_uri: base_uri,
        client_id: client_id,
        client_secret: client_secret
      )
    end

    def currencies(page: 1)
      request.get(uri: '/currencies', query: { page: page })
    end

    def professions(page: 1)
      request.get(uri: '/professions', query: { page: page })
    end

    def taxes(page: 1, only_standard: false)
      filter = {}
      filter = { filter: { standard: 1 } } if only_standard
      request.get(uri: '/taxes', query: { page: page }.merge(filter))
    end

    def invoice(id:)
      request.get(uri: "/invoices/#{id}")
    end

    def create_user(attributes: {})
      data = { data: { attributes: attributes } }
      request.post(uri: '/users', body: data)
    end

    def create_company(attributes: {})
      data = { data: { attributes: attributes } }
      request.post(uri: '/companies', body: data)
    end

    def create_invoice(attributes: {})
      data = attributes
      request.post(uri: '/invoices', body: data)
    end
  end
end
