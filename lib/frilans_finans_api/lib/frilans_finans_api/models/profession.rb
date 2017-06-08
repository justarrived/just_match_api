# frozen_string_literal: true

module FrilansFinansApi
  class Profession
    include Walker

    def self.index(page: 1, client: FrilansFinansApi.config.client_klass.new)
      response = client.professions(page: page)
      Document.new(response)
    end

    def self.show(id:, client: FrilansFinansApi.config.client_klass.new)
      response = client.profession(id: id)
      Document.new(response)
    end
  end
end
