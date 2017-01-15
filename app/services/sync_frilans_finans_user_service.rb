# frozen_string_literal: true
class SyncFrilansFinansUserService
  def self.call(user:)
    id = user.frilans_finans_id
    action = id.nil? ? :create : :update

    attributes = FrilansFinans::UserWrapper.attributes(user, action: action)

    arguments = { attributes: attributes }
    arguments[:id] = id if id
    FrilansFinansApi::User.public_send(action, **arguments)
  end
end
