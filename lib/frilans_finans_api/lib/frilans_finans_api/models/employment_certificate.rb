# frozen_string_literal: true

module FrilansFinansApi
  class EmploymentCertificate
    def self.create(attributes:, client: FrilansFinansApi.config.client_klass.new)
      client.create_employment_certificate(attributes: attributes)
      nil
    end
  end
end
