# frozen_string_literal: true

class JobDigestSubscriberSyncJob < ApplicationJob
  def perform(user:)
    JobDigestSubscriberSyncService.call(user: user)
  end
end
