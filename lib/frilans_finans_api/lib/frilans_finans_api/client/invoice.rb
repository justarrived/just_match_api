# frozen_string_literal: true
module FrilansFinansApi
  class Invoice
    def self.create(attributes:, client: DEFAULT_CLIENT_KLASS.new)
      response = client.create_invoice(attributes: attributes)
      Document.new(response.body)
    end

    def self.show(id:, client: DEFAULT_CLIENT_KLASS.new)
      response = client.invoice(id: id)
      Document.new(response.body)
    end
  end
end
