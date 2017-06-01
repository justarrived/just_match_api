# frozen_string_literal: true

module CountryCodes
  COUNTRY_CODES = Set.new(YAML.load_file('data/country_codes.yml')['codes']).freeze

  def self.all
    COUNTRY_CODES.to_a
  end

  def self.exists?(country_code)
    COUNTRY_CODES.include?(country_code)
  end
end
