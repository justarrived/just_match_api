require 'csv'
require 'wintrgarden_exporter/base_exporter'

module Wintrgarden
  COUNTRY_MAP = {
    'TF' =>  :ignore, # Frankrike
    'AX' =>  :ignore, # Finland
    'BQ' =>  :ignore, # som jag förstår används inte denna beteckning längre, och delades upp, så blir svår att slå ihop
    'EH' =>  :ignore, # Marocko
    'UM' =>  :ignore, # USA
    'CW' =>  :ignore, # Nederländerna
  }.freeze
end

module Wintrgarden
  class Users < BaseExporter
    def initialize(datums = nil)
      @datums = datums
    end

    def header
      %w[
        id firstName lastName nationalIdentityCard gender email phoneNumber residencePostalCode residenceCountrySubdivision
        nationality_code employmentServiceRegistrationTimestamp linkedInUrl
        createDate lastLoginDate
      ]
    end

    def to_row(model)
      [
        model.id,
        model.first_name,
        model.last_name,
        model.ssn,
        wintrgarden_gender(model.gender),
        model.email,
        model.phone,
        model.zip,
        model.city,
        COUNTRY_MAP.fetch(model.country_of_origin, model.country_of_origin),
        model.arbetsformedlingen_registered_at,
        model.linkedin_url,
        model.created_at,
        model.updated_at
      ]
    end

    def wintrgarden_gender(gender)
      return 'Male' if gender == 'male'
      return 'Female' if gender == 'female'
      'Do not wish to say' if gender == 'other'

      ''
    end
  end
end
