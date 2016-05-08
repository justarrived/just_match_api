# frozen_string_literal: true
module FrilansFinans
  module UserWrapper
    def self.attributes(user)
      {
        user: {
          email: user.email,
          street: user.street || '',
          city: '',
          zip: user.zip,
          country: user.country_name.upcase,
          cellphone: user.phone,
          first_name: user.first_name,
          last_name: user.last_name,
          social_security_number: user.ssn
        }
      }
    end
  end
end
