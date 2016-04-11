# frozen_string_literal: true

module FrilansFinansApi
  class User
    def self.create(attributes:, client: FrilansFinansApi.client_klass.new)
      response = client.create_user(attributes: attributes)
      Document.new(response.body)
    end
  end
end
