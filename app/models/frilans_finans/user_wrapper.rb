# frozen_string_literal: true
module FrilansFinans
  module UserWrapper
    def self.attributes(user)
      # NOTE: FFAPIv2: Wrap in data/attributes instead of user
      attrs = {
        user: {
          email: user.email,
          street: user.street || '',
          city: '',
          zip: user.zip || '',
          country: user.country_name.upcase,
          cellphone: user.phone,
          first_name: user.first_name,
          last_name: user.last_name
        }
      }

      ssn = user.ssn
      # Company users doesn't need to have ssn set
      attrs[:user][:social_security_number] = format_ssn(ssn) unless ssn.nil?
      attrs
    end

    def self.format_ssn(ssn)
      # Frilans Finans wants the social security number as an integer
      # We store the ssn on the format YYMMDD-XXXX, so we need to remove '-'
      # NOTE: FFAPIv2: ssn should be a string!
      ssn.delete('-').to_i
    end
  end
end
