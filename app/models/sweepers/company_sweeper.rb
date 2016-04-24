# frozen_string_literal: true
module Sweepers
  class CompanySweeper
    def self.create_frilans_finans(scope = Company)
      scope.needs_frilans_finans_id.find_each(batch_size: 1000) do |company|
        user = company.find_frilans_finans_user
        attributes = {
          name: company.name,
          country: company.country_name,
          street: company.street,
          city: company.city,
          zip: company.zip,
          send_to_email: company.email,
          user_id: user.frilans_finans_id
        }
        ff_company = FrilansFinansApi::Company.create(attributes: attributes)
        ff_id = ff_company.resource.id

        next if ff_id.nil?

        company.frilans_finans_id = ff_id.to_i
        company.save!
      end
    end
  end
end
