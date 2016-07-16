# frozen_string_literal: true
module SecureGenerator
  DEFAULT_TOKEN_LENGTH = 128

  def self.token(length: DEFAULT_TOKEN_LENGTH)
    SecureRandom.hex(length / 2)
  end
end
