# frozen_string_literal: true
class SwedishBankAccount
  ERRORS_MAP = {
    BankTools::SE::Errors::TOO_SHORT               => :too_short,
    BankTools::SE::Errors::TOO_LONG                => :too_long,
    BankTools::SE::Errors::INVALID_CHARACTERS      => :invalid_characters,
    BankTools::SE::Errors::BAD_CHECKSUM            => :bad_checksum,
    BankTools::SE::Errors::UNKNOWN_CLEARING_NUMBER => :unknown_clearing_number
  }.freeze

  ACCOUNT_ERRORS = [:invalid_characters, :too_short, :too_long].freeze
  CLEARING_NUMBER_ERRORS = [:unknown_clearing_number].freeze
  SERIAL_NUMBER_ERRORS = [:bad_checksum].freeze

  KNOWN_ERRORS = {
    account: ACCOUNT_ERRORS,
    clearing_number: CLEARING_NUMBER_ERRORS,
    serial_number: SERIAL_NUMBER_ERRORS
  }.freeze

  UnknownErrorType = Class.new(ArgumentError)

  attr_reader :clearing_number, :serial_number, :bank, :errors

  def initialize(account_number)
    BankTools::SE::Account.new(account_number).tap do |tool|
      tool.valid?
      tool.normalize

      @errors = tool.errors.map { |error| ERRORS_MAP.fetch(error) }

      @clearing_number = tool.clearing_number
      @serial_number = tool.serial_number
      @bank = tool.bank
      @valid = tool.valid?
    end
  end

  def valid?
    @valid
  end

  def errors_by_field
    KNOWN_ERRORS.keys.map do |field|
      errors = errors_for(field)
      next if errors.empty?

      block_given? ? yield(field, errors) : [field, errors]
    end.compact
  end

  def errors_for(field)
    known_errors = known_errors_for(field)
    errors.select { |error| known_errors.include?(error) }
  end

  def known_errors_for(field)
    KNOWN_ERRORS[field] || fail(UnknownErrorType, "Unknown field: #{field.inspect}")
  end
end
