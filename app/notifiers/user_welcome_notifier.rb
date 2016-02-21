# frozen_string_literal: true
class UserWelcomeNotifier
  def self.call(user:)
    UserMailer.
      welcome_email(user: user).
      deliver_later
  end
end
