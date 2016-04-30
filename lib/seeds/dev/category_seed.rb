# frozen_string_literal: true
module Dev
  class CategorySeed < BaseSeed
    def self.call
      client = FrilansFinansApi::FixtureClient.new
      FrilansFinansImporter.professions(client: client)
    end
  end
end
