# frozen_string_literal: true

require 'seeds/base_seed'

class CategorySeed < BaseSeed
  def self.call
    new.call
  end

  def call
    log_seed(Category) do
      FrilansFinansImporter.professions
    end
  end

  def client
    # The API isn't live yet, so use a fixture client by default
    FrilansFinansAPI::FixtureClient.new
  end
end
