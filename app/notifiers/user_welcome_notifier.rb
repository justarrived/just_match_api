# frozen_string_literal: true
class UserWelcomeNotifier < BaseNotifier
  def self.call(user:)
    notify do
      UserMailer.
        welcome_email(user: user)
    end
  end
end
