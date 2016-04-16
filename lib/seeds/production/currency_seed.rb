# frozen_string_literal: true
require 'seeds/base_seed'

class CurrencySeed < BaseSeed
  def self.call
    new.call
  end

  def call
    log_seed(Currency) do
      FrilansFinansImporter.currencies
    end
  end
end
