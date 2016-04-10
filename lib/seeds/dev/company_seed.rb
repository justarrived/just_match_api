# frozen_string_literal: true
require 'seeds/base_seed'

module Dev
  class CompanySeed < BaseSeed
    def self.call
      max_companies = max_count_opt('MAX_COMPANIES', 10)

      log_seed(Company) do
        max_companies.times do
          Company.create!(
            name: Faker::Company.name,
            cin: Faker::Company.swedish_organisation_number
          )
        end
      end
    end
  end
end
