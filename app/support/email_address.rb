# frozen_string_literal: true

class EmailAddress
  def self.normalize(email)
    Mail::Address.new(email)
      &.address
      &.strip
      &.downcase
  rescue Mail::Field::ParseError
    email&.strip&.downcase
  end
end
