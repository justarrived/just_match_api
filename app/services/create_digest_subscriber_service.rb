# frozen_string_literal: true

class CreateDigestSubscriberService
  def self.call(current_user:, user_id: nil, email: nil)
    email = EmailAddress.normalize(email)
    user_id = user_id

    if user_id && (current_user.admin? || user_id.to_s == current_user.id.to_s)
      return DigestSubscriber.find_or_create_by(user_id: user_id)
    end

    if email && email == current_user.email
      return DigestSubscriber.find_or_create_by(user_id: current_user.id)
    end

    if email
      return DigestSubscriber.find_or_create_by(email: email)
    end

    DigestSubscriber.new
  end
end
