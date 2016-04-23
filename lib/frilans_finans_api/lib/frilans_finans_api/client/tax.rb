# frozen_string_literal: true

module FrilansFinansApi
  class Tax
    include Walker

    def self.index(page: 1, client: FrilansFinansApi.client_klass.new)
      response = client.taxes(page: page)
      Document.new(response.body)
    end
  end
end
