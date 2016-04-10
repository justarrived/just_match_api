# frozen_string_literal: true

module FrilansFinansApi
  class User
    def self.create(attributes:, client: DEFAULT_CLIENT_KLASS.new)
      response = client.create_user(attributes: attributes)
      Document.new(response.body)
    end
  end
end
