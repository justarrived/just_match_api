# frozen_string_literal: true
module FrilansFinansApi
  class User
    include Walker

    def self.create(attributes:, client: FrilansFinansApi.config.client_klass.new)
      response = client.create_user(attributes: attributes)
      Document.new(response)
    end

    def self.update(id:, attributes:, client: FrilansFinansApi.config.client_klass.new)
      response = client.update_user(id: id, attributes: attributes)
      Document.new(response)
    end

    def self.index(page: 1, email: nil, client: FrilansFinansApi.config.client_klass.new)
      response = client.users(page: page, email: email)
      Document.new(response)
    end

    def self.show(id:, client: FrilansFinansApi.config.client_klass.new)
      response = client.user(id: id)
      Document.new(response)
    end
  end
end
