# frozen_string_literal: true
module FrilansFinans
  module UserWrapper
    def self.attributes(user)
      # Frilans Finans wants the social security number as an integer
      # We store the ssn on the format YYMMDD-XXXX, so we need to remove '-'
      ssn = format_ssn(user.ssn)
      {
        user: {
          email: user.email,
          street: user.street || '',
          city: '',
          zip: user.zip || '',
          country: user.country_name.upcase,
          cellphone: user.phone,
          first_name: user.first_name,
          last_name: user.last_name,
          social_security_number: ssn
        }
      }
    end

    def self.format_ssn(ssn)
      ssn.delete('-').to_i
    end
  end
end
