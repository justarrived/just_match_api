# frozen_string_literal: true
module FrilansFinansApi
  class User
    def self.create(attributes:, client: FrilansFinansApi.client_klass.new)
      response = client.create_user(attributes: attributes)
      Document.new(response.body)
    end

    def self.update(id:, attributes:, client: FrilansFinansApi.client_klass.new)
      response = client.update_user(id: id, attributes: attributes)
      Document.new(response.body)
    end

    def self.show(id:, client: FrilansFinansApi.client_klass.new)
      response = client.user(id: id)
      Document.new(response.body)
    end
  end
end
