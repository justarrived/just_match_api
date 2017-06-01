# frozen_string_literal: true

require 'seeds/base_seed'

module Dev
  class FrilansFinansTermSeed < BaseSeed
    def self.call
      max_ff_terms = max_count_opt('MAX_FF_TERMS_SEED', 3)

      log_seed(FrilansFinansTerm) do
        max_ff_terms.times do
          FrilansFinansTerm.create(company: true, body: Faker::Lorem.paragraph(2))
          FrilansFinansTerm.create(company: false, body: Faker::Lorem.paragraph(2))
        end
      end
    end
  end
end
