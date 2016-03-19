# frozen_string_literal: true
require 'seeds/dev/base_seed'

class CompanySeed < BaseSeed
  def self.call
    max_companies = max_count_opt('MAX_COMPANIES', 10)

    log '[db:seed] Company'
    max_companies.times do
      Company.create!(
        name: Faker::Company.name,
        cin: Faker::Company.swedish_organisation_number
      )
    end
  end
end
