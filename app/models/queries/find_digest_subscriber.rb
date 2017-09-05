# frozen_string_literal: true

module Queries
  class FindDigestSubscriber
    def self.from_uuid_or_user_id(current_user:, uuid_or_user_id:)
      if current_user.admin? || current_user.id.to_s == uuid_or_user_id.to_s
        subscriber = DigestSubscriber.find_by(user_id: uuid_or_user_id)
        return subscriber if subscriber
      end

      DigestSubscriber.find_by!(uuid: uuid_or_user_id)
    end
  end
end
