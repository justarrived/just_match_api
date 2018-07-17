# frozen_string_literal: true

class CreateDigestSubscriberService
  def self.call(current_user:, user_id: nil, email: nil)
    email = EmailAddress.normalize(email)
    subscriber = nil
    user_id = user_id.presence
    email = email.presence

    if user_id && (current_user.admin? || user_id.to_s == current_user.id.to_s)
      subscriber = DigestSubscriber.find_or_initialize_by(user_id: user_id)
    elsif email && email == current_user.email
      subscriber = DigestSubscriber.find_or_initialize_by(user_id: current_user.id)
    elsif email && (user = User.find_by(email: email))
      subscriber = DigestSubscriber.find_or_initialize_by(user_id: user.id)
    elsif email
      subscriber = DigestSubscriber.find_or_initialize_by(email: email)
    end

    if subscriber
      subscriber.deleted = false
      subscriber.save
      return subscriber
    end

    DigestSubscriber.new.tap(&:validate)
  end
end
