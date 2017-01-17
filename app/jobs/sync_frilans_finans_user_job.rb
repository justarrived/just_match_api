# frozen_string_literal: true
class SyncFrilansFinansUserJob < ActiveJob::Base
  def perform(user:)
    SyncFrilansFinansUserService.call(user: user)
  end
end
