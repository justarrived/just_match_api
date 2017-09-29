# frozen_string_literal: true

class SyncFrilansFinansUserService
  def self.call(user:)
    id = user.frilans_finans_id
    attributes = FrilansFinans::UserWrapper.attributes(user)

    if id
      FrilansFinansAPI::User.update(id: id, attributes: attributes)
    else
      FrilansFinansAPI::User.create(attributes: attributes)
    end
  end
end
