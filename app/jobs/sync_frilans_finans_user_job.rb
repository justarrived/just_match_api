# frozen_string_literal: true
class SyncFrilansFinansUserJob
  def perform(user:)
    SyncFrilansFinansUserService.call(user: user)
  end
end
