# frozen_string_literal: true

module FrilansFinansApi
  class Profession
    include Walker

    def self.index(page: 1, client: DEFAULT_CLIENT_KLASS.new)
      response = client.professions(page: page)
      Document.new(response.body)
    end
  end
end
