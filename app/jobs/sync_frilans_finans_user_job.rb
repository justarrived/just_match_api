# frozen_string_literal: true

class SyncFrilansFinansUserJob < ApplicationJob
  def perform(user:)
    SyncFrilansFinansUserService.call(user: user)
  end
end
