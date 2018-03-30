# frozen_string_literal: true

class SyncFrilansFinansUserService
  def self.call(user:)
    id = user.frilans_finans_id
    attributes = FrilansFinans::UserWrapper.attributes(user)

    if id
      FrilansFinansAPI::User.update(id: id, attributes: attributes)
    else
      ff_user = FrilansFinansAPI::User.create(attributes: attributes)
      ff_id = ff_user.resource.id
      return if ff_id.nil?

      user.frilans_finans_id = ff_id
      user.save!
    end
  end
end
