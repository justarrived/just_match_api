# frozen_string_literal: true
module FrilansFinans
  module CompanyWrapper
    def self.attributes(company:, user:)
      {
        company: {
          name: company.name,
          country: company.country_name.upcase,
          street: company.street,
          city: company.city,
          zip: company.zip,
          send_to_email: company.email,
          user_id: user.frilans_finans_id
        }
      }
    end
  end
end
