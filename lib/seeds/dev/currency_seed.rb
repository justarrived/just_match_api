# frozen_string_literal: true

module Dev
  class CurrencySeed < BaseSeed
    def self.call
      client = FrilansFinansAPI::FixtureClient.new
      FrilansFinansImporter.currencies(client: client)
    end
  end
end
