# frozen_string_literal: true
class IBANAccount
  # Errors map between IBANTools errors and "ours"
  ERRORS_MAP = {
    too_short: :too_short,
    bad_chars: :bad_characters,
    bad_check_digits: :bad_check_digits,
    unknown_country_code: :unknown_country_code,
    bad_length: :bad_length,
    bad_format: :bad_format
  }.freeze

  attr_reader :errors

  def initialize(account_number)
    @iban = IBANTools::IBAN.new(account_number)
    @errors = @iban.validation_errors.map { |error| ERRORS_MAP.fetch(error) }
  end

  def valid?
    @errors.empty?
  end

  def country_code
    @iban.country_code
  end

  def to_s
    @iban.prettify
  end
end
