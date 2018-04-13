# frozen_string_literal: true

class SyncFrilansFinansUserService
  def self.call(user:)
    attributes = FrilansFinans::UserWrapper.attributes(user)

    if id = user.frilans_finans_id
      return FrilansFinansAPI::User.update(id: id, attributes: attributes)
    end

    FrilansFinansAPI::User.create(attributes: attributes).tap do |document|
      ff_id = document.resource.id
      if ff_id
        user.frilans_finans_id = ff_id
        user.save!
      end
    end
  end
end
