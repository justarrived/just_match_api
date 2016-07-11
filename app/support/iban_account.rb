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

  # IBAN2007Identifier (taken from https://github.com/salesking/sepa_king/blob/a8213d39d82ba39110073db19d25d13ed9f17118/lib/sepa_king/validator.rb)
  REGEX = /\A[A-Z]{2,2}[0-9]{2,2}[a-zA-Z0-9]{1,30}\z/

  attr_reader :errors

  def initialize(account_number)
    # Remove all spaces so that we can strictly enforce the format
    number = account_number.to_s.delete(' ')

    @iban = IBANTools::IBAN.new(number)
    @errors = @iban.validation_errors.map { |error| ERRORS_MAP.fetch(error) }
    @errors << :bad_format unless number.match(REGEX)
  end

  def valid?
    @errors.empty?
  end

  def country_code
    @iban.country_code
  end

  def to_s
    @iban.code
  end

  def prettify
    @iban.prettify
  end
end
