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
      request.get(uri: '/currencies', query: build_query(page: page))
    end

    def professions(page: 1)
      request.get(uri: '/professions', query: build_query(page: page))
    end

    def salaries(invoice_id:, page: 1)
      request.get(uri: "/invoices/#{invoice_id}/salaries", query: build_query(page: page))
    end

    def users(page: 1)
      request.get(uri: '/users', query: build_query(page: page))
    end

    def taxes(page: 1, only_standard: false)
      filter = {}
      filter = { filter: { standard: 1 } } if only_standard
      request.get(uri: '/taxes', query: build_query(page: page).merge(filter))
    end

    def invoice(id:)
      request.get(uri: "/invoices/#{id}")
    end

    def user(id:)
      request.get(uri: "/users/#{id}")
    end

    def create_user(attributes: {})
      request.post(uri: '/users', body: build_attributes(attributes))
    end

    def create_company(attributes: {})
      request.post(uri: '/companies', body: build_attributes(attributes))
    end

    def create_employment_certificate(attributes: {})
      request.post(uri: '/employment-certificate', body: build_attributes(attributes))
    end

    def create_invoice(attributes: {})
      request.post(uri: '/invoices', body: build_attributes(attributes))
    end

    def update_invoice(id:, attributes: {})
      request.patch(uri: "/invoices/#{id}", body: build_attributes(attributes))
    end

    def update_user(id:, attributes: {})
      request.patch(uri: "/users/#{id}", body: build_attributes(attributes))
    end

    private

    def build_attributes(attributes)
      { data: { attributes: attributes } }
    end

    def build_query(page:)
      { page: { number: page } }
    end
  end
end
