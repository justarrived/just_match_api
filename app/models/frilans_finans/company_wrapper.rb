# frozen_string_literal: true
module FrilansFinans
  module CompanyWrapper
    def self.attributes(company:)
      {
        name: company.name,
        country: company.country_name.upcase,
        street: company.street,
        city: company.city,
        zip: company.zip,
        send_to_email: company.billing_email,
        user_id: AppConfig.frilans_finans_company_creator_user_id
      }
    end
  end
end
