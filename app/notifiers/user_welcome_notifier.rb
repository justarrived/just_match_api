# frozen_string_literal: true
class UserWelcomeNotifier < BaseNotifier
  def self.call(user:)
    UserMailer.
      welcome_email(user: user).
      deliver_later
  end
end
