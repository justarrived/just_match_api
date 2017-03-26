# frozen_string_literal: true
class UserWelcomeNotifier < BaseNotifier
  def self.call(user:)
    envelope = UserMailer.welcome_email(user: user)
    notify(envelope)
  end
end
