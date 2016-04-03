# frozen_string_literal: true
require 'seeds/dev/base_seed'

module Dev
  class CompanySeed < BaseSeed
    def self.call
      max_companies = max_count_opt('MAX_COMPANIES', 10)
      before_count = Company.count

      log 'Creating Companies'
      max_companies.times do
        Company.create!(
          name: Faker::Company.name,
          cin: Faker::Company.swedish_organisation_number
        )
      end

      log "Created #{Company.count - before_count} Companies"
    end
  end
end
