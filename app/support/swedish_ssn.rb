# frozen_string_literal: true

class SwedishSSN
  NORMALIZED_LENGTH = 11

  def self.valid?(ssn)
    Personnummer.new(ssn).valid?
  rescue ArgumentError
    false
  end

  def self.normalize(ssn)
    return ssn unless valid?(ssn)

    Personnummer.new(ssn).to_s
  end
end
