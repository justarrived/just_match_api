# frozen_string_literal: true
module FrilansFinansApi
  class Salary
    def self.index(invoice_id:, page: 1, client: FrilansFinansApi.client_klass.new)
      response = client.salaries(invoice_id: invoice_id, page: page)
      Document.new(response)
    end
  end
end
