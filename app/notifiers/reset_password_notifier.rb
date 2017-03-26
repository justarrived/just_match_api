# frozen_string_literal: true
class ResetPasswordNotifier < BaseNotifier
  def self.call(user:)
    envelope = UserMailer.reset_password_email(user: user)
    notify(envelope)
  end
end
