# frozen_string_literal: true

class PostalCode
  SWEDISH_CODE_LENGTH = 5

  def initialize(input)
    @postal_code = normalize_zip(input)
  end

  def to_s
    @postal_code
  end

  private

  def normalize_zip(input)
    postal_code = input.to_s.strip.delete(' ')

    return postal_code.insert(3, ' ') if postal_code.length == SWEDISH_CODE_LENGTH
    postal_code
  end
end
