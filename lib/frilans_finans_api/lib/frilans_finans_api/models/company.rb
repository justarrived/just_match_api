# frozen_string_literal: true

module FrilansFinansApi
  class Company
    def self.create(attributes:, client: FrilansFinansApi.client_klass.new)
      response = client.create_company(attributes: attributes)
      Document.new(response)
    end
  end
end
