# frozen_string_literal: true

class DigestSubscriberSyncJob < ApplicationJob
  def perform(user:)
    DigestSubscriberSyncService.call(user: user)
  end
end
