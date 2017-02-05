# frozen_string_literal: true
module FrilansFinans
  module CompanyWrapper
    def self.attributes(company:, user:)
      {
        name: company.name,
        country: company.country_name.upcase,
        street: company.street,
        city: company.city,
        zip: company.zip,
        send_to_email: company.billing_email,
        user_id: user.frilans_finans_id # TODO: Figure out which is the best user_id to user here...
      }
    end
  end
end
