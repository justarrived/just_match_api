# frozen_string_literal: true
module FrilansFinans
  module UserWrapper
    def self.attributes(user)
      # Frilans Finans wants the social security number as an integer
      ssn = user.ssn.to_i
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
  end
end
