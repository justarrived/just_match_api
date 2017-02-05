# frozen_string_literal: true
class SyncFrilansFinansUserService
  def self.call(user:)
    id = user.frilans_finans_id
    action = id.nil? ? :create : :update

    arguments = { attributes: FrilansFinans::UserWrapper.attributes(user) }
    arguments[:id] = id if id

    FrilansFinansApi::User.public_send(action, **arguments)
  end
end
