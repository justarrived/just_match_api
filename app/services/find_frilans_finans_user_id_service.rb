# frozen_string_literal: true

class FindFrilansFinansUserIdService
  def self.call(email:)
    document = FrilansFinansApi::User.index(email: email)
    document.resource.id
  end
end
