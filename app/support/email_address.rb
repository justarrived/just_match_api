# frozen_string_literal: true

class EmailAddress
  EMAIL_REGEX = /\A.+@.+\..+\z/

  def self.normalize(email)
    Mail::Address.new(email)
      &.address
      &.strip
      &.downcase
  rescue Mail::Field::ParseError
    email&.strip&.downcase
  end

  def self.valid?(email)
    normalize(email.to_s).match?(EMAIL_REGEX)
  end
end
