# frozen_string_literal: true
class EmailAddress
  def self.normalize(email)
    email&.strip&.downcase
  end
end
