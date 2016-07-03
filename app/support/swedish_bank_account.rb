# frozen_string_literal: true
class SwedishBankAccount
  ERRORS_MAP = {
    BankTools::SE::Errors::TOO_SHORT               => :too_short,
    BankTools::SE::Errors::TOO_LONG                => :too_long,
    BankTools::SE::Errors::INVALID_CHARACTERS      => :invalid_characters,
    BankTools::SE::Errors::BAD_CHECKSUM            => :bad_checksum,
    BankTools::SE::Errors::UNKNOWN_CLEARING_NUMBER => :unknown_clearing_number
  }.freeze

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
end
