# frozen_string_literal: true

class JobDigestSubscriberSyncService
  def self.call(user:)
    JobDigestSubscriber.where(email: user.email).map do |subscriber|
      subscriber.update!(user: user, email: nil)
      subscriber
    end
  end
end
