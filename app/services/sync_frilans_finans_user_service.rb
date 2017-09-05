# frozen_string_literal: true

class SyncFrilansFinansUserService
  def self.call(user:)
    id = user.frilans_finans_id
    attributes = FrilansFinans::UserWrapper.attributes(user)

    if id
      FrilansFinansApi::User.update(id: id, attributes: attributes)
      return
    end

    resource = FrilansFinansApi::User.create(attributes: attributes)
    user.update(frilans_finans_id: resource.id) if resource.id.present?
  end
end
