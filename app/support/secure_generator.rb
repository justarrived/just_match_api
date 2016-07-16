# frozen_string_literal: true
module SecureGenerator
  def self.token(length: 96)
    SecureRandom.hex(length / 2)
  end
end
