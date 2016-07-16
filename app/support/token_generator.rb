# frozen_string_literal: true
module TokenGenerator
  def self.generate
    SecureRandom.uuid.tr('-', '')
  end
end
