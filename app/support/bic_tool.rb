# frozen_string_literal: true
class BICTool
  # BIC rules (taken from http://www.theswiftcodes.com/)
  #     First 4 characters - bank code (letters)
  #     Next 2 characters  - ISO 3166-1 alpha-2 country code (letters)
  #     Next 2 characters  - location code (letters and digits)
  #     Last 3 characters  - branch code, optional (letters and digits)
  REGEX = /\A[A-Z]{6,6}[A-Z2-9][A-NP-Z0-9]([A-Z0-9]{3,3}){0,1}\z/

  attr_reader :errors, :bic, :country_code

  def initialize(bic_number)
    @bic = bic_number.to_s.delete(' ').upcase

    @errors = []
    @errors << :bad_format unless @bic.match(REGEX)

    @country_code = nil
    if @errors.empty?
      @country_code = @bic[4..5]
      @errors << :bad_country_code unless CountryCodes.exists?(@country_code)
    end
  end

  def valid?
    @errors.empty?
  end
end
