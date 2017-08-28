# frozen_string_literal: true

class DigestSubscriberSyncService
  def self.call(user:)
    DigestSubscriber.where(email: user.email).map do |subscriber|
      subscriber.update!(user: user, email: nil)
      subscriber
    end
  end
end
